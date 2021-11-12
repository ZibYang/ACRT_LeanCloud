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
    @EnvironmentObject var arObjectLibraryViewModel :ARObjectLibraryViewModel
    @EnvironmentObject var placementSetting : PlacementSetting


    @Binding var showMesh: Bool
    @Binding var takeSnapshootNow: Bool
    
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
        
        placementSetting.sceneObserver = arViewModel.arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            updateScene(for: arViewModel.arView)
        })
        
        return arViewModel.arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        if (httpManager.statusLoc == 1) {
            arViewModel.onLocalizationResult(manager: httpManager)
            arViewModel.placeInherentARObjects(arObjectLibrary: arObjectLibraryViewModel)
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
        if placementSetting.isInCreationMode == true && placementSetting.doPlaceModel == true {
            if let confirmedModel = placementSetting.confirmedModel, let modelEntity = confirmedModel.modelEntity {
                self.place(modelEntity, in: arView)
                self.placementSetting.doPlaceModel = false
            }
        }
        
    }
    
    private func place(_ modelEntity: ModelEntity, in arView : ARView) {
//        let clonedEntity = modelEntity.clone(recursive: true)
//        
//        clonedEntity.generateCollisionShapes(recursive: true)
//        
//        arView.installGestures([.translation, .rotation], for: clonedEntity)
//        
//        let anchorEntity = AnchorEntity(plane: .any)
//        anchorEntity.transform.scale = SIMD3<Float>(0.1, 0.1, 0.1) // DEBUG(BCH)
//        anchorEntity.addChild(clonedEntity)
//        arView.scene.addAnchor(anchorEntity)
//        
//        print("Added modelEntity")
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
