//
//  ScenePersistenceHelper.swift
//  FocusEntityPlacer
//
//  Created by baochong on 2021/11/11.
//

import Foundation
import RealityKit
import ARKit
import LeanCloud
import simd

extension simd_float4x4 {
    init?(_ string: String) {
        let prefix = "simd_float4x4"
        guard string.hasPrefix(prefix) else { return nil }

        let csv = string.dropFirst(prefix.count).components(separatedBy: ",")
        let filtered = csv.map { $0.filter { Array("-01234567890.").contains($0) } }
        let floats = filtered.compactMap(Float.init)
        guard floats.count == 16 else { return nil }

        let f0 = SIMD4<Float>(Array(floats[0...3]))
        let f1 = SIMD4<Float>(Array(floats[4...7]))
        let f2 = SIMD4<Float>(Array(floats[8...11]))
        let f3 = SIMD4<Float>(Array(floats[12...15]))

        self = simd_float4x4(f0, f1, f2, f3)
    }
}


class PersistenceHelperViewModel: ObservableObject {
    var anchors: [ModelAnchor] = []
    
    // ARKit saves the state of the scene and any ARAnchors in the scene.
    // ARKit does not save any models or anchor entities.
    // So whenever we load a scene from file, we will use the model and ARAnchor pair for placement.
    func uploadScene(for arView: CustomARView, at anchorEntities: [AnchorEntity], with usrname : String, poseWToARKit : simd_float4x4 ) {
        print("Save scene to local filesystem.")
        // find anchorentity -> add entity
//            check if scene is already exist
            let query = LCQuery(className: "Scene")
            query.whereKey("scene_name", .equalTo("default"))
            _ = query.find { result in
                switch result {
                case .success(objects: let scenes):
                    var object_id: LCString? = nil
                    if scenes.count > 0 {
                        object_id = scenes[0].objectId
                        print("[LH] \(String(describing: object_id))")
                    } else {
                        print("[LH] no query scene in database")
                    }
                    
                    var scene = LCObject(className: "Scene")
                    if object_id != nil {
                        scene = LCObject(className: "Scene", objectId: object_id!)
                    }
                    do {
                        try scene.set("creator", value: usrname)
                        try scene.set("scene_name", value: "default")
                        
                        var object_names: [String] = []
                        var object_poses: [String] = []
                        
                        for anchorEntity in anchorEntities {
                            if AnchorIdentifierHelper.decode(identifier: anchorEntity.name)[0] == usrname {
                                let poseWToAnchor = poseWToARKit * anchorEntity.transformMatrix(relativeTo: nil)
                                // save username , anchor.name , poseWToAnchor
                                print("[LH] append \(anchorEntity.name) ")
                                object_names.append(anchorEntity.name)
                                object_poses.append(poseWToAnchor.debugDescription)
                            }
                        }
                        try scene.set("object_names", value: object_names)
                        try scene.set("object_poses", value: object_poses)
                        
                        _ = scene.save { result in
                            switch result {
                            case .success:
                                // 成功保存之后，执行其他逻辑
                                break
                            case .failure(error: let error):
                                // 异常处理
                                print("[LH] \(error)")
                            }
                        }
                    } catch {
                        print("[LH] \(error)")
                    }
                case .failure(error: let error):
                    print("[LH] \(error)")
                }
            }

    }
    
    func downloadScene(poseWToARKit : simd_float4x4) -> [ModelAnchor]{
        print("Load scene from local filesystem.")
        // return models which is appended into confirmedModel
    
        
        let query = LCQuery(className: "Scene")
        query.whereKey("scene_name", .equalTo("default"))
        _ = query.find { result in
            switch result {
            case .success(objects: let scenes):
                if scenes.count > 0 {
                    let scene = scenes[0]
                    let object_names = scene.get("object_names") as! LCArray
                    let object_poses = scene.get("object_poses") as! LCArray
                    

                    for i in 0..<object_names.value.count {
                        let obeject_name: String = (object_names[i] as! LCString).value
                        let object_pose: String = (object_poses[i] as! LCString).value
                        print("[LH] \(obeject_name) \(object_pose)")
                        
                        let name = AnchorIdentifierHelper.decode(identifier: obeject_name)[1]
                        print("[LH] \(name)")
                        guard let trans = simd_float4x4(object_pose) else {
                            return
                        }
                        let poseARKitToModel = poseWToARKit.inverse * trans
                        print("[LH] \(String(describing: poseARKitToModel))")
                        
                        let anchor = ModelAnchor(modelName: name, transform : poseARKitToModel, anchorName: obeject_name)
                        self.anchors.append(anchor)
                    }
                    
                } else {
                    print("[LH] no query scene in database")
                }

            case .failure(error: let error):
                print("[LH] \(error)")
            }
        }
        
        return []
    }
}
