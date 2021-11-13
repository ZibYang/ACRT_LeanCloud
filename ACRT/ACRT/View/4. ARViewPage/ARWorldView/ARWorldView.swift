//
//  ARCameraView.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/1.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

// MARK: Info.plist Settings
// Since we did't choose a AR app at the first begining, so we have to add some key personally,
// which includs: *Required Device capabilites* and *Privacy-Camera Usage Description*

import ARKit
import SwiftUI
import RealityKit
import Foundation

import SwiftUI

struct ARWorldView:  UIViewRepresentable {
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var httpManager: HttpAuth
    @EnvironmentObject var usdzManagerViewModel : USDZManagerViewModel 
    @EnvironmentObject var placementSetting : PlacementSetting
    @EnvironmentObject var sceneManager : SceneManagerViewModel
    @EnvironmentObject var modelDeletionManager: ModelDeletionManagerViewModel


    @Binding var showMesh: Bool
    @Binding var takeSnapshootNow: Bool
    var userName : String
    var testBool : Bool = false
    @StateObject var exploreAnchorManager : ExploreAnchorManagerViewModel =  ExploreAnchorManagerViewModel()
    
    func makeUIView(context: Context) -> ARView {
        let config = ARWorldTrackingConfiguration()
        
        // Plane Detection
        config.planeDetection = [.horizontal, .vertical]
        // Environment Texturing
        if #available(iOS 12, *) {
            config.environmentTexturing = .automatic
        }
        // Person segmantantion
        if (ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth)){
            config.frameSemantics.insert(.personSegmentationWithDepth)
            print("[Debug] People occlusion on")
        }else{
            print("[Debug] People occlusion not available on this devices")
        }
        // Use LiDAR to promote the scan ablity
        if(ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)){
            config.sceneReconstruction = .mesh
            print("[Debug] Scene reconstruction on")
        }else{
            print("[Debug] The device does not support LiDAR")
        }
        
        
        // Scene Understanding
//        arViewModel.arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arViewModel.arView.environment.sceneUnderstanding.options.insert(.receivesLighting)
        
        // ARCoachingOverlay
        arViewModel.arView.addCoaching()
        
        // Debug
       
        if showMesh {
            arViewModel.arView.debugOptions.insert(.showAnchorOrigins)
            arViewModel.arView.debugOptions.insert(.showSceneUnderstanding)
        }
        arViewModel.arView.session.run(config)
        
        arViewModel.arView.modelDeletionManager = modelDeletionManager
        
        placementSetting.sceneObserver = arViewModel.arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            self.updateScene(for: arViewModel.arView)
            self.handlePersistence(for: arViewModel.arView)
        })
        
        return arViewModel.arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        if (httpManager.statusLoc == 1 && self.exploreAnchorManager.isRendered == false) {
            print("DEBUG(BCH): isRendered : \(self.exploreAnchorManager.isRendered)")
            self.exploreAnchorManager.isRendered = true
            arViewModel.onLocalizationResult(manager: httpManager)
            let exploreModels = self.exploreAnchorManager.getTransformedModelAnchors(poseARKitToW: arViewModel.poseARKitToW)
            self.placementSetting.modelConfirmedForPlacement.append(contentsOf: exploreModels)
        }
        if showMesh {
            arViewModel.arView.debugOptions.insert(.showAnchorOrigins)
            arViewModel.arView.debugOptions.insert(.showSceneUnderstanding)
        }else{
            arViewModel.arView.debugOptions.remove(.showAnchorOrigins)
            arViewModel.arView.debugOptions.remove(.showSceneUnderstanding)
        }
        if takeSnapshootNow{
            arView.snapshot(saveToHDR: false) {image in
                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            }
            takeSnapshootNow = false
        }
    }
    
    private func updateScene(for arView: CustomARView) {
        arView.foucsEntity?.isEnabled = placementSetting.isInCreationMode
        if let modelAnchor = self.placementSetting.modelConfirmedForPlacement.popLast(), let modelEntity = usdzManagerViewModel.createModelList.getUSDZModelEntity(modelName: modelAnchor.modelName) {
            if modelAnchor.anchorName != nil && modelAnchor.transform != nil {
                // Anchor needs to be created from placement
                let anchorName = modelAnchor.anchorName!
                print("anchor \(anchorName) has transform \(modelAnchor.transform)")
                let anchor = ARAnchor(name: anchorName, transform: modelAnchor.transform!)
                if AnchorIdentifierHelper.decode(identifier: anchorName)[0] != userName {
                    self.place(modelEntity, for: anchor, in: arView, enableGesture: false)
                } else {
                    self.place(modelEntity, for: anchor, in: arView, enableGesture: true)
                }
            }else if let transform = getTransformForPlacement(in: arView) {
                // Anchor needs to be created from placement
                let anchorName = AnchorIdentifierHelper.encode(userName: userName, modelName: modelAnchor.modelName)
                let anchor = ARAnchor(name:anchorName, transform: transform)
                self.place(modelEntity, for: anchor, in: arView, enableGesture: true)
            }
        
    }
        
    }
    
    private func place(_ modelEntity: ModelEntity, for anchor: ARAnchor, in arView : ARView, enableGesture: Bool) {
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        if enableGesture == true {
            arView.installGestures([.translation, .rotation], for: clonedEntity)
        }
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.name = anchor.name! + "|entity"
        anchorEntity.addChild(clonedEntity)
        //anchorEntity.anchoring = AnchoringComponent(anchor)
        arView.session.add(anchor: anchor)
        arView.scene.addAnchor(anchorEntity)
        self.sceneManager.anchorEntities.append(anchorEntity)

        print("Added modelEntity")
    }
    
    private func handlePersistence(for arView:  CustomARView) {
        if self.sceneManager.shouldUploadSceneToCloud {
            PersistenceHelperViewModel.uploadScene(for: arView, at: self.sceneManager.persistenceUrl, with: userName, poseWToARKit: arViewModel.poseARKitToW)
            self.sceneManager.shouldUploadSceneToCloud = false
        } else if self.sceneManager.shouldDownloadSceneFromCloud {
            let modelAnchors = PersistenceHelperViewModel.downloadScene(poseWToARKit: arViewModel.poseARKitToW)
            self.placementSetting.modelConfirmedForPlacement.append(contentsOf: modelAnchors)
            self.sceneManager.shouldDownloadSceneFromCloud = false
        }
    }
    
    private func getTransformForPlacement(in arView: ARView) -> simd_float4x4? {
        guard let query = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .any) else {
            return nil
        }
        guard let raycastResult = arView.session.raycast(query).first else {return nil}
        return raycastResult.worldTransform
    }
    
    
}


extension ARView: ARCoachingOverlayViewDelegate{
    func addCoaching(){
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        // coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15, *) {
            coachingOverlay.goal = .geoTracking // FIXME: Not working
        }else{
            coachingOverlay.goal = .anyPlane
        }
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // TODO: ?
        print("[Debug] Deactivate")
    }
    
    public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // TODO: ?
    }
}
