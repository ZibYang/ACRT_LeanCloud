//
//  ScenePersistenceHelper.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/5.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation
import RealityKit
import ARKit
import LeanCloud
import simd

extension simd_float4x4 {
    init?(_ string: String) {
        let prefix = "simd_float4x4"
        guard string.hasPrefix(prefix) else {
            print("[LH] prefix nil")
            return nil
        }

        let csv = string.dropFirst(prefix.count).components(separatedBy: ",")
        let filtered = csv.map { $0.filter { Array("-+01234567890.e").contains($0) } }
        let floats = filtered.compactMap(Float.init)
        guard floats.count == 16 else {
            print("[LH] count != 16")
            return nil
        }

        let f0 = SIMD4<Float>(Array(floats[0...3]))
        let f1 = SIMD4<Float>(Array(floats[4...7]))
        let f2 = SIMD4<Float>(Array(floats[8...11]))
        let f3 = SIMD4<Float>(Array(floats[12...15]))

        self = simd_float4x4(f0, f1, f2, f3)
    }
}


class PersistenceHelperViewModel: ObservableObject {
    var anchors: [ModelAnchor] = []
    let CLASS_NAME: String = "Objects"
    // let SCENE_NAME: String = "default"
    var objects_dict: [String: LCString] = [:]
    
    var info = ""
    @Published var uploadIsDone = true
    @Published var downloadIsDone = true
    
    // ARKit saves the state of the scene and any ARAnchors in the scene.
    // ARKit does not save any models or anchor entities.
    // So whenever we load a scene from file, we will use the model and ARAnchor pair for placement.
    func uploadScene(for arView: CustomARView, at anchorEntities: [AnchorEntity], with usrname : String, poseARKitToW : simd_float4x4 , in sceneName: String) {
        self.uploadIsDone = false
        self.info = ""
        print("Save scene to local filesystem.")
        
//      first check if object is already exist
        let query = LCQuery(className: CLASS_NAME)
        query.whereKey("scene_name", .equalTo(sceneName))
        _ = query.find { result in
            switch result {
            case .success(objects: let objects):
                if objects.count > 0 {
                    for object in objects {
                        let object_id:LCString = object.objectId!
                        let object_name:String = (object.get("object_name") as! LCString).value
                        print("[LH] get \(String(describing: object_name)) ==> \(String(describing: object_id))")
                        var _ = self.objects_dict.updateValue(object_id, forKey: object_name)
                    }
                } else {
                    print("[LH] no query scene in database")
                }
                
                var objects: [LCObject] = []
                for anchorEntity in anchorEntities {
                    if AnchorIdentifierHelper.decode(identifier: anchorEntity.name)[0] == usrname {
                        var modelTransform = matrix_identity_float4x4
                        if anchorEntity.children.count > 0,  let modelEntity = anchorEntity.children[0] as? ModelEntity {
                            modelTransform = modelEntity.transformMatrix(relativeTo: nil)
                        } else {
                            modelTransform = anchorEntity.transformMatrix(relativeTo: nil)
                        }
                        let poseWToAnchor = poseARKitToW.inverse * modelTransform
                        // save username , anchor.name , poseWToAnchor
                        var object = LCObject(className: self.CLASS_NAME)
                        if self.objects_dict[anchorEntity.name] != nil {
                            object = LCObject(className: self.CLASS_NAME, objectId: self.objects_dict[anchorEntity.name]!)
                        }
                        do {
                            try object.set("creator", value: usrname)
                            try object.set("scene_name", value: sceneName)
                            try object.set("object_name", value: anchorEntity.name)
                            try object.set("object_pose", value: poseWToAnchor.debugDescription)
                        } catch {
                            print("[LH] \(error)")
                        }
                        objects.append(object)
                    }
                }
                
                _ = LCObject.save(objects, completion: { (result) in
                    switch result {
                    case .success:
                        self.uploadIsDone = true
                        self.info = "Upload Successfully"
                        print("[LH] upload success !!")
                    case .failure(error: let error):
                        self.uploadIsDone = true
                        self.info = "Uploading failed"
                        print(error)
                    }
                })
                

            case .failure(error: let error):
                self.uploadIsDone = true
                self.info = "Uploading failed"
                print("[LH] \(error)")
            }
        }
    }
    
    func downloadScene(poseARKitToW : simd_float4x4, in sceneName: String) -> [ModelAnchor]{
        print("Load scene from local filesystem.")
        self.downloadIsDone = false
        self.info = ""
        // return models which is appended into confirmedModel
        
        let query = LCQuery(className: "Objects")
        query.whereKey("scene_name", .equalTo(sceneName))
        _ = query.find { result in
            switch result {
            case .success(objects: let objects):
                if objects.count > 0 {
                    print("[LH] pre download \(objects.count) objects")
                    for i in 0..<objects.count {
                        let object_name:String = (objects[i].get("object_name") as! LCString).value
                        let object_pose:String = (objects[i].get("object_pose") as! LCString).value
                        
                        print("[LH] \(i) get \(object_name) \(object_pose)")

                        let name = AnchorIdentifierHelper.decode(identifier: object_name)[1]
                        print("[LH] \(name)")
                        guard let trans = simd_float4x4(object_pose) else {
                            print("[LH] \(i) get trans failed pose: \(object_pose)")
                            return
                        }
                        let poseARKitToModel = poseARKitToW * trans

                        let anchor = ModelAnchor(modelName: name, transform : poseARKitToModel, anchorName: object_name)
                        self.anchors.append(anchor)
                    }

                } else {
                    print("[LH] no query objects in database")
                }
                print("[LH] download \(objects.count) objects successfully.")
                self.downloadIsDone = true
                self.info = "download \(objects.count) objects successfully."
            case .failure(error: let error):
                self.downloadIsDone = true
                self.info = "downloading failed "
                print("[LH] \(error)")
            }
        }

        return []
    }
}
