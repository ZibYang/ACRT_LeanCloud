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
//        initializeInherentModelsShelf()
        initializeInherentModelsQiuShi()
//        initializeInherentModelsQiuShiSensetime()

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

        let model1 = ModelAnchor(modelName: "qs_AppStore", pos: simd_float3(0.35, -0.9024, 4.4489), rotation: rotationMatrix, scale: simd_float3(0.4, 0.4, 0.4))
        let model2 = ModelAnchor(modelName: "qs_AppleLogo_right", pos: simd_float3(7.4656, -3.0853, 6.3871), rotation: rotationMatrix, scale: simd_float3(50,50,50))
        let model3 = ModelAnchor(modelName: "qs_AppleLogo_left", pos: simd_float3(15.4656, -3.085,6.3871), rotation: rotationMatrix, scale: simd_float3(1,1,1))
        let model4 = ModelAnchor(modelName: "qs_AppleMusic", pos: simd_float3(18.1737, -7.88608, 14.1996), rotation: rotationMatrix, scale: simd_float3(40,40,40))
        let model5 = ModelAnchor(modelName: "qs_Calendar", pos: simd_float3(20.559, -1.39, 2.754), rotation: rotationMatrix, scale: simd_float3(40,40,40))
        let model6 = ModelAnchor(modelName: "qs_Hello", pos: simd_float3(12.1793, -1.3317, 8.66942), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model7 = ModelAnchor(modelName: "Title", pos: simd_float3(12.5103, -7.78159, 6.9709), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model8 = ModelAnchor(modelName: "qs_Camera", pos: simd_float3(8.61513, -7.44404, 14.6042), rotation: rotationMatrix, scale: simd_float3(8,8,8))
        let model9 = ModelAnchor(modelName: "qs_Hello", pos: simd_float3(-8.03984, -2.56496, 9.19537), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model10 = ModelAnchor(modelName: "qs_SwiftChangeTheWorld", pos: simd_float3(33.907, -2.3223, 7.93072), rotation: rotationMatrix, scale: simd_float3(4,4,4))
        modelAnchorList = [model1, model2, model3, model4, model5,model6, model7,model8, model9, model10]
    
    }
    
    func initializeInherentModelsShelf()  {
        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
        let worldFront = simd_float3(0,0,-1) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))

            //Shelf
        let model1 = ModelAnchor(modelName: "qs_Hello", pos: simd_float3(0.341545, -0.727689, 5.92317), rotation: rotationMatrix, scale: simd_float3(10.0, 10.0, 10.0))
    
        let model2 = ModelAnchor(modelName: "qs_AppleLogo_left", pos: simd_float3(-3.38882, 0.0870665, 0.155429), rotation: rotationMatrix, scale: simd_float3(1, 1, 1))
        
        let model3 = ModelAnchor(modelName: "qs_AppleLogo_right", pos: simd_float3(-7.73664609,  0.536159  , -4.19239709), rotation: rotationMatrix, scale: simd_float3(100, 100, 100))
    
//            let model3 = ModelAnchor(modelName: "AppleLogo", pos: simd_float3(4.05483, 0.582852, 0.191444), rotation: rotationMatrix, scale: simd_float3(0.4,0.4,0.4))
            
        modelAnchorList = [model1, model2, model3]
    }
    
    func initializeInherentModelsQiuShiSensetime() {
        let worldUp =  simd_float3(0,0,1) // = local y in world axis
        let worldFront = simd_float3(1,0,0) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        //Qiushi
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
        let model1 = ModelAnchor(modelName: "qs_AppStore", pos: simd_float3(62.734833, -1.281104, -0.013874), rotation: rotationMatrix, scale: simd_float3(0.4, 0.4, 0.4))
        let model2 = ModelAnchor(modelName: "qs_AppleLogo_right", pos: simd_float3(57.134, 3.7623, 1.928), rotation: rotationMatrix, scale: simd_float3(100,100,100))
        let model3 = ModelAnchor(modelName: "qs_AppleLogo_left", pos: simd_float3(61.406, 3.7623, 1.928), rotation: rotationMatrix, scale: simd_float3(0.8,0.8,0.8))
        let model4 = ModelAnchor(modelName: "qs_AppleMusic", pos: simd_float3(57.474, 13.969, 4.2688), rotation: rotationMatrix, scale: simd_float3(40,40,40))
        let model5 = ModelAnchor(modelName: "qs_Calendar", pos: simd_float3(65.32, 18.528, 0.0), rotation: rotationMatrix, scale: simd_float3(40,40,40))
        let model6 = ModelAnchor(modelName: "qs_Hello", pos: simd_float3(59.135, 11.017, 0), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model7 = ModelAnchor(modelName: "Title", pos: simd_float3(55.291, 8.356, 5.2607), rotation: rotationMatrix, scale: simd_float3(40,40,40))
        let model8 = ModelAnchor(modelName: "qs_Camera", pos: simd_float3(55.046, 5.023, 5.50), rotation: rotationMatrix, scale: simd_float3(8,8,8))
        let model9 = ModelAnchor(modelName: "qs_Hello", pos: simd_float3(59.135, 11.017, 0.001), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model10 = ModelAnchor(modelName: "qs_SwiftChangeTheWorld", pos: simd_float3(60.92, 31.17, 2.27), rotation: rotationMatrix, scale: simd_float3(4,4,4))
        modelAnchorList = [model1, model2, model3, model4, model5,model6, model7,model8, model9,model10]

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
