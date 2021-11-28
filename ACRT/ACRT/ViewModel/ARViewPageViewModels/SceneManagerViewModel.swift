//
//  SceneManagerViewModel.swift
//  ACRT
//
//  Created by baochong on 2021/11/12.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation
import RealityKit
import UIKit

class SceneManagerViewModel: ObservableObject {
    var shouldUploadSceneToCloud: Bool = false
    var shouldDownloadSceneFromCloud: Bool = false
    @Published var anchorEntities: [AnchorEntity] = []
    @Published var deleteHint = false
    @Published var deleteHintMessage = ""
    var createdModelCount = 0
    
    lazy var persistenceUrl: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create : true).appendingPathComponent("arf.persistence")
        } catch {
            fatalError("Unable to get persistenceUrl \(error.localizedDescription)")
        }
    }()
    
    func ClearCreativeAnchors() {
        createdModelCount = 0
        let length = anchorEntities.count
        for anchorEntity in anchorEntities {
            if AnchorIdentifierHelper.decode(identifier: anchorEntity.name)[0] != rootUserName {
                print("Removing anchorEntity with id :\(String(describing: anchorEntity.anchorIdentifier))")
                createdModelCount += 1
                anchorEntity.removeFromParent()
            }
        }
        for i in 0..<length {
            let index  = length - i - 1
            if AnchorIdentifierHelper.decode(identifier: anchorEntities[index].name)[0] != rootUserName {
                anchorEntities.remove(at: index)
            }
        }
        if createdModelCount != 0{
            deleteHintMessage = "All models have been deleted"
        }else{
            deleteHintMessage = "No model can be delete"
        }
        deleteHint.toggle()
    }
    
    func ClearWholeAnchors() {
        for anchorEntity in anchorEntities {
            print("Removing anchorEntity with id :\(String(describing: anchorEntity.anchorIdentifier))")
            anchorEntity.removeFromParent()
            
        }
        anchorEntities.removeAll()
    }
    
    func offsetAnchors(transform : simd_float4x4) {
        for anchorEntity in anchorEntities {
            let oldTransform : simd_float4x4 = anchorEntity.transformMatrix(relativeTo: nil)
            anchorEntity.setTransformMatrix(transform * oldTransform, relativeTo: nil)
        }
    }
    
    func updateAnchorByName(anchorName: String, transform : simd_float4x4) {
        for anchorEntity in anchorEntities {
            if anchorEntity.name == anchorName {
                anchorEntity.setTransformMatrix(transform, relativeTo: nil)
            }
        }
    }
    
    func IsAnchorExisted(anchorName: String) -> Bool {
        return anchorEntities.contains(where: {$0.name == anchorName})
    }
}
