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
    func uploadScene(for arView: CustomARView, at anchorEntities: [AnchorEntity], with usrname : String, poseARKitToW : simd_float4x4 , in sceneName: String) {
        print("Save scene to local filesystem.")
        
        var objects: [LCObject] = []
        for anchorEntity in anchorEntities {
            if AnchorIdentifierHelper.decode(identifier: anchorEntity.name)[0] == usrname {
                let poseWToAnchor = poseARKitToW.inverse * anchorEntity.transformMatrix(relativeTo: nil)
                // save username , anchor.name , poseWToAnchor
                let object = LCObject(className: "Objects")
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
                print("[LH] upload success !!")
            case .failure(error: let error):
                print(error)
            }
        })
    }
    
    func downloadScene(poseARKitToW : simd_float4x4, in sceneName: String) -> [ModelAnchor]{
        print("Load scene from local filesystem.")
        // return models which is appended into confirmedModel
        
        let query = LCQuery(className: "Objects")
        query.whereKey("scene_name", .equalTo(sceneName))
        _ = query.find { result in
            switch result {
            case .success(objects: let objects):
                if objects.count > 0 {
                    for i in 0..<objects.count {
                        let object_name:String = (objects[i].get("object_name") as! LCString).value
                        let object_pose:String = (objects[i].get("object_pose") as! LCString).value
                        
                        print("[LH] get \(object_name) \(object_pose)")

                        let name = AnchorIdentifierHelper.decode(identifier: object_name)[1]
                        print("[LH] \(name)")
                        guard let trans = simd_float4x4(object_pose) else {
                            return
                        }
                        let poseARKitToModel = poseARKitToW * trans
                        print("[LH] \(String(describing: poseARKitToModel))")

                        let anchor = ModelAnchor(modelName: name, transform : poseARKitToModel, anchorName: object_name)
                        self.anchors.append(anchor)
                    }

                } else {
                    print("[LH] no query objects in database")
                }

            case .failure(error: let error):
                print("[LH] \(error)")
            }
        }

        return []
    }
}
