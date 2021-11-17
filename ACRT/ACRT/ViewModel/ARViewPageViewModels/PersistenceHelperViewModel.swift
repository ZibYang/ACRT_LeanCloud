//
//  ScenePersistenceHelper.swift
//  FocusEntityPlacer
//
//  Created by baochong on 2021/11/11.
//

import Foundation
import RealityKit
import ARKit

class PersistenceHelperViewModel {
    // ARKit saves the state of the scene and any ARAnchors in the scene.
    // ARKit does not save any models or anchor entities.
    // So whenever we load a scene from file, we will use the model and ARAnchor pair for placement.
    class func uploadScene(for arView: CustomARView, at persistenceUrl: URL, with modelPrefix : String, poseWToARKit : simd_float4x4 ) {
        print("Save scene to local filesystem.")
        // find anchorentity -> add entity
        
        // find anchor
        print(arView.scene.anchors)
        for anchor in arView.scene.anchors {
            let anchorName = anchor.name
            if anchorName.hasPrefix(modelPrefix) {
                let modelName = anchorName.dropFirst(modelPrefix.count)
                print("ARSession: didAdd anchor for modelName: \(modelName)")
                let poseWToAnchor = poseWToARKit * anchor.transform.matrix
                // save username , name , poseWToAnchor
            }
        }
        
    }
    
    class func downloadScene(poseWToARKit : simd_float4x4) -> [ModelAnchor]{
        print("Load scene from local filesystem.")
        // return models which is appended into confirmedModel
        return []
    }
}
