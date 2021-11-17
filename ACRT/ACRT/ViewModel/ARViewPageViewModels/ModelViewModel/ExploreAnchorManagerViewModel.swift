//
//  USDZLibraryViewModel.swift
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

class ExploreAnchorManagerViewModel : ObservableObject {
    
    var modelAnchorList : [ModelAnchor] = []
    var isRendered : Bool = false
    
    init() {
        initializeInherentModelsShelf()
    }
    
    func initializeInherentModelsInTime() {
        //InTime
        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
        let worldFront = simd_float3(-0.94613601,  0.26701994, -0.18310379) // = local z in world axis
        let worldRight = normalize(cross(worldUp, worldFront))
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
        let model1 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(-4.87282, -16.316, 23.8932), rotation: rotationMatrix, scale: simd_float3(4,4,4))
        modelAnchorList = [model1]
    }
    
    func initializeInherentModelsQiuShi() {
        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
        let worldFront = simd_float3(0,0,-1) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        //Qiushi
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
        let model1 = ModelAnchor(modelName: "Hello_World_Globe", pos: simd_float3(12.4161, -2.48313, 9.02723), rotation: rotationMatrix, scale: simd_float3(1,1,1))

        let model2 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(-8.45376, -2.92693, 9.33032), rotation: rotationMatrix, scale: simd_float3(1,1,1))

        let model3 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(33.3995, -2.83004, 7.99316), rotation: rotationMatrix, scale: simd_float3(1,1,1))
        
        let model4 = ModelAnchor(modelName: "Title", pos: simd_float3(112.4831, -7.83952, 13.8966), rotation: rotationMatrix, scale: simd_float3(20,20,20))
        
        let model5 = ModelAnchor(modelName: "flight", pos: simd_float3(-0.822067, -9.01792, 11.3803), rotation: rotationMatrix, scale: simd_float3(10,10,10))
        
        let model6 = ModelAnchor(modelName: "gear", pos: simd_float3(25.6591, -8.51259, 10.7296), rotation: rotationMatrix, scale: simd_float3(10,10,10))
        
        let model7 = ModelAnchor(modelName: "hammer", pos: simd_float3(1.90713, -0.380037, 2.17264), rotation: rotationMatrix, scale: simd_float3(10,10,10))
        
        let model8 = ModelAnchor(modelName: "SwiftChangeTheWorld.usdz", pos: simd_float3(22.2034, -0.347333, 1.56218), rotation: rotationMatrix, scale: simd_float3(10,10,10))
        
        
        modelAnchorList = [model1, model2, model3, model4, model5, model6, model7, model8]

    }
    
    func initializeInherentModelsShelf()  {
        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
        let worldFront = simd_float3(0,0,-1) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))

            //Shelf
        let model1 = ModelAnchor(modelName: "hello", pos: simd_float3(0.341545, -0.727689, 5.92317), rotation: rotationMatrix, scale: simd_float3(1.0, 1.0, 1.0))
    
        let model2 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(-3.38882, 0.0870665, 0.155429), rotation: rotationMatrix, scale: simd_float3(1.0, 1.0, 1.0))
        
        let model3 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(-7.73664609,  0.536159  , -4.19239709), rotation: rotationMatrix, scale: simd_float3(1.0, 1.0, 1.0))
    
//            let model3 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(4.05483, 0.582852, 0.191444), rotation: rotationMatrix, scale: simd_float3(0.4,0.4,0.4))
            
        modelAnchorList = [model1, model2, model3]
    }
    
    func initializeInherentModelsQiuShiSensetime() {
        let worldUp =  simd_float3(0,0,1) // = local y in world axis
        let worldFront = simd_float3(1,0,0) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        //Qiushi
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
        let model1 = ModelAnchor(modelName: "hello", pos: simd_float3(59.538483, 9.173322, 0.584023), rotation: rotationMatrix, scale: simd_float3(1,1,1))

        let model2 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(59.506565, 30.814552, 1.062348), rotation: rotationMatrix, scale: simd_float3(1,1,1))

        let model3 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(59.398548, -11.554224, 1.109176), rotation: rotationMatrix, scale: simd_float3(1,1,1))
        modelAnchorList = [model1, model2, model3]

    }
    
    func getTransformedModelAnchors(poseARKitToW: simd_float4x4) -> [ModelAnchor]{
        var transformedModelAnchors  : [ModelAnchor] = []
        for anchor in modelAnchorList {
            var modelAnchor = getTransformedModelAnchor(modelAnchor: anchor, T_arkit_w: poseARKitToW)
            if modelAnchor.transform != nil {
                modelAnchor.anchorName =  AnchorIdentifierHelper.encode(userName: "admin", modelName: modelAnchor.modelName)
                transformedModelAnchors.append(modelAnchor)
            }
            
        }
        return transformedModelAnchors
    }

}
