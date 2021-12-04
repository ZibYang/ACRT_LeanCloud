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

// [snapShot] reference: https://github.com/josh-wayda/ARScreenShot

import ARKit
import SwiftUI
import RealityKit
import Foundation

import SwiftUI
import LeanCloud

struct ARWorldView:  UIViewRepresentable {
    @StateObject var exploreAnchorManager : ExploreAnchorManagerViewModel =  ExploreAnchorManagerViewModel()
    
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var httpManager: HttpAuth
    @EnvironmentObject var usdzManagerViewModel : USDZManagerViewModel 
    @EnvironmentObject var placementSetting : PlacementSetting
    @EnvironmentObject var sceneManager : SceneManagerViewModel
    @EnvironmentObject var modelDeletionManager: ModelDeletionManagerViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var persistence: PersistenceHelperViewModel
    @EnvironmentObject var messageModel: MessageViewModel
    
    @Binding var showMesh: Bool
    @Binding var takeSnapshootNow: Bool
    @Binding var disableEntity: Bool
    @Binding var showOcclusion: Bool
    var testBool : Bool = false
    
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
        // arViewModel.arView.environment.sceneUnderstanding.options.insert(.occlusion)
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
        arViewModel.arView.messageModel = messageModel
        
        placementSetting.sceneObserver = arViewModel.arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            self.updateModels()
            self.updateScene(for: arViewModel.arView)
            self.updateMessageText(for: arViewModel.arView)
            self.handlePersistence(for: arViewModel.arView)
        })
        
        return arViewModel.arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        if (self.httpManager.statusLoc == 1) {
            self.arViewModel.onLocalizationResult(manager: httpManager)
            if (self.exploreAnchorManager.isRendered == false) {
                print("DEBUG(BCH): isRendered : \(self.exploreAnchorManager.isRendered)")
                self.exploreAnchorManager.isRendered = true
                let exploreModels = self.exploreAnchorManager.getTransformedModelAnchors(poseARKitToW: arViewModel.poseARKitToW)
                print("DEBUG(BCH): initial \(exploreModels.count) objects")
                self.placementSetting.modelWaitingForPlacement.append(contentsOf: exploreModels)
            }
            let transform : simd_float4x4 = self.arViewModel.poseARKitToW * self.arViewModel.lastPoseARKitToW.inverse
            self.sceneManager.offsetAnchors(transform: transform)
 
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
        if showOcclusion{
            arViewModel.arView.environment.sceneUnderstanding.options.insert(.occlusion)
        }else{
            arViewModel.arView.environment.sceneUnderstanding.options.remove(.occlusion)
        }
    }
    
    private func updateModels() {
        if let modelAnchor = self.placementSetting.modelWaitingForPlacement.popLast() {
            let model = modelAnchor.model
            if model.modelEntity != nil {
                print("DEBUG(BCH): load \(modelAnchor.model.modelName) ")
                self.placementSetting.modelConfirmedForPlacement.append(modelAnchor)
            } else {
                print("DEBUG(BCH): nil model \(modelAnchor.model.modelName)")
                model.asyncLoadEntity() {  completed, error in
                    if completed {
                        print("DEBUG(BCH): load nil model \(modelAnchor.model.modelName)")
                        self.placementSetting.modelConfirmedForPlacement.append(modelAnchor)
                    }
                }
            }
        }
    }
    
    private func updateMessageText(for arView: CustomARView) {
        if arView.is_loading {
                return
        }
        
        var BoardCount = 0
        for anchor in self.sceneManager.anchorEntities {
            if AnchorIdentifierHelper.decode(identifier: anchor.name)[1] == "user_text_MessageBoard.reality" {
                BoardCount += 1
            }
        }
        
        if BoardCount == arView.messageBoardCount {
            if BoardCount == 0 {
                return
            }
        } else {
            arView.messageBoardCount = BoardCount
            arView.forceSet = true
        }
            
        let query = LCQuery(className: "Message")
        query.whereKey("createdAt", .descending)
        query.limit = 5
        
        _ = query.find { result in
            switch result {
            case .success(objects: let objects):
//                arView.all_message = ""
                var new_message = ""
                let obj_count = objects.count
                for i in stride(from: obj_count-1, through: 0, by: -1) {
                    let creator:String = (objects[i].get("creator") as! LCString).value
                    var message:String = (objects[i].get("message") as! LCString).value
                        
//                    print("[meg] get message \(creator): \(message)")
                    var length = message.count
                    while length > 40 {
                        message.insert("\n", at: message.index(message.startIndex, offsetBy: 40))
                        length -= 40
                    }
                    new_message += "\(creator) \(message)\n"
                }
//                print("[meg] \(new_message)")
//                print("[meg] \(arView.all_message)")
                if arView.forceSet || new_message != arView.all_message {
                    for anchor in self.sceneManager.anchorEntities {
                        if AnchorIdentifierHelper.decode(identifier: anchor.name)[1] == "user_text_MessageBoard.reality" {
//                            let anchor = arView.scene.findEntity(named: anchor.name)

                            let text = anchor.children[0].children[0].children[1].children[0].children[0].children[0] as! ModelEntity
                            
                            var textComponent:ModelComponent = (text.components[ModelComponent])!
                            print("[meg] set \(new_message)")
                            textComponent.mesh = .generateText(new_message, extrusionDepth: 0.01,
                                                               font: .systemFont(ofSize: 0.03),
                                                               containerFrame: CGRect(),
                                                               alignment: .left,
                                                               lineBreakMode: .byCharWrapping)

                            text.components.set(textComponent)
                            arView.all_message = new_message
                        }
                    }
                    if arView.forceSet {
                        arView.forceSet = false
                    }
                }
                arView.is_loading = false
            case .failure(error: let error):
                print("[meg] \(error)")
            }
        }
        arView.is_loading = true
    }
    
    private func updateScene(for arView: CustomARView) {
        arView.foucsEntity?.isEnabled = placementSetting.isInCreationMode && !disableEntity && placementSetting.selectedModel != "" && !messageModel.isMessaging
        if let modelAnchor = self.placementSetting.modelConfirmedForPlacement.popLast(), let modelEntity = modelAnchor.model.modelEntity {
            if modelAnchor.anchorName != nil && modelAnchor.transform != nil &&  sceneManager.IsAnchorExisted(anchorName: modelAnchor.anchorName!) {
                // update anchor existed at the scene
                print("DEBUG(BCH): update \(modelAnchor.anchorName) with transform\n \(modelAnchor.transform)")
                sceneManager.updateAnchorByName(anchorName: modelAnchor.anchorName!, transform: modelAnchor.transform!)
            }
            else if let anchorName = modelAnchor.anchorName, let transform = modelAnchor.transform {
                // Place anchor by transform (place explore models, downloaded models )
                print("DEBUG(BCH): place \(anchorName) with transform\n \(transform)")
                if AnchorIdentifierHelper.decode(identifier: anchorName)[0] != userModel.userName {
                    self.place(modelEntity, for: transform, with: anchorName, in: arView, enableGesture: false)
                } else {
                    self.place(modelEntity, for: transform, with: anchorName, in: arView, enableGesture: true)
                }
            }else if let transform = getTransformForPlacement(in: arView) {
                // Place anchor by raycast (place create model)
                let anchorName = AnchorIdentifierHelper.encode(userName: userModel.userName, modelName: modelAnchor.model.modelName)
                var finalTransform = transform
                if modelAnchor.transform != nil {
                    finalTransform = finalTransform * modelAnchor.transform!
                }
                print("DEBUG(BCH): place \(anchorName) with ray cast transform\n \(transform)")
                self.place(modelEntity, for: finalTransform, with: anchorName,  in: arView, enableGesture: true)
            }
    }
        
    }
    
    private func place(_ modelEntity: Entity, for transform: simd_float4x4, with anchorName: String, in arView : ARView, enableGesture: Bool) {
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        
        if enableGesture == true, let clonedModelEntity = clonedEntity as? ModelEntity{
            print("DEBUG(BCH): enable gesture for \(clonedEntity.name)")
            arView.installGestures([.rotation, .scale, .translation], for: clonedModelEntity)
        }
        
        let anchorEntity = AnchorEntity(world: transform)
        anchorEntity.name = anchorName
        anchorEntity.addChild(clonedEntity)
        //anchorEntity.anchoring = AnchoringComponent(anchor)
        //arView.session.add(anchor: anchorPosition)
        arView.scene.addAnchor(anchorEntity)
        self.sceneManager.anchorEntities.append(anchorEntity)

        print("Added modelEntity\(anchorName) \(clonedEntity)")
    }
    
    private func handlePersistence(for arView:  CustomARView) {
        if self.arViewModel.hasBeenLocalized == false || self.userModel.isSignedIn == false {
            return
        }
        if self.sceneManager.shouldUploadSceneToCloud {
            persistence.uploadScene(for: arView, at: self.sceneManager.anchorEntities, with: userModel.userName, poseARKitToW: arViewModel.poseARKitToW, in: "QiushiSensetime")
            self.sceneManager.shouldUploadSceneToCloud = false
        } else if self.sceneManager.shouldDownloadSceneFromCloud {
            let modelAnchors = persistence.downloadScene(poseARKitToW: arViewModel.poseARKitToW, in: "QiushiSensetime")
            self.placementSetting.modelWaitingForPlacement.append(contentsOf: modelAnchors)
            self.sceneManager.shouldDownloadSceneFromCloud = false
        }
        
        if persistence.anchors.count > 0 {
            print("DEBUG(BCH): download \(persistence.anchors.count)")
            self.placementSetting.modelWaitingForPlacement.append(contentsOf: persistence.anchors)
            persistence.anchors.removeAll()
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
