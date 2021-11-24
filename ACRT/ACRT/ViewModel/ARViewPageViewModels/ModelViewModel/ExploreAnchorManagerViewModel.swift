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
//        initializeInherentModelsQiuShi()
        initializeInherentModelsQiuShiSensetime()

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

        let model1 = ModelAnchor(modelName: "qs_AppStore", pos: simd_float3(0.35, -0.9024, 4.4489), rotation: rotationMatrix, scale: simd_float3(15,15,15))
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
        let model1 = ModelAnchor(modelName: "qs_AppStore", pos: simd_float3(62.734833, -1.281104, -0.013874), rotation: rotationMatrix, scale: simd_float3(30,30,30))
         let model2 = ModelAnchor(modelName: "qs_AppleLogo_right", pos: simd_float3(57.134, 3.7623, 1.928), rotation: rotationMatrix, scale: simd_float3(50,50,50))
         let model3 = ModelAnchor(modelName: "qs_AppleLogo_left", pos: simd_float3(61.406, 12.7623, 1.928), rotation: rotationMatrix, scale: simd_float3(1,1,1))
         let model4 = ModelAnchor(modelName: "qs_AppleMusic", pos: simd_float3(57.474, 13.969, 5.5088), rotation: rotationMatrix, scale: simd_float3(60,60,60))
         let model5 = ModelAnchor(modelName: "qs_Calendar", pos: simd_float3(65.32, 18.528, 0.0), rotation: rotationMatrix, scale: simd_float3(40,40,40))
         let model6 = ModelAnchor(modelName: "qs_Hello", pos: simd_float3(60.135, 10.017, 1), rotation: rotationMatrix, scale: simd_float3(10,10,10))
         let model7 = ModelAnchor(modelName: "qs_Title", pos: simd_float3(55.291, 8.356, 9.2607), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model8 = ModelAnchor(modelName: "qs_Camera", pos: simd_float3(55.046, 5.023, 6.4), rotation: rotationMatrix, scale: simd_float3(12,12,12))
         let model9 = ModelAnchor(modelName: "qs_Swift", pos: simd_float3(60.92, -9, 2.27), rotation: rotationMatrix, scale: simd_float3(15,15,15))
         let model10 = ModelAnchor(modelName: "qs_SwiftChangeTheWorld", pos: simd_float3(60.92, 31.17, 2.27), rotation: rotationMatrix, scale: simd_float3(4,4,4))
        let model11 = ModelAnchor(modelName: "qs_Facetime", pos: simd_float3(56.0926, -3.03, 2.27), rotation: rotationMatrix, scale: simd_float3(6.3,6.3,6.3))
        let model12 = ModelAnchor(modelName: "qs_Health", pos: simd_float3(56.0926, 19.03, 2.27), rotation: rotationMatrix, scale: simd_float3(6.3, 6.3, 6.3))
        let model13 = ModelAnchor(modelName: "qs_Home", pos: simd_float3(67.41,14.31, -0.86), rotation: rotationMatrix, scale: simd_float3(6.3,6.3,6.3))
        let model14 = ModelAnchor(modelName: "qs_iMessage", pos: simd_float3(67.41,3.08, -0.86), rotation: rotationMatrix, scale: simd_float3(6.3, 6.3, 6.3))
        let model15 = ModelAnchor(modelName: "qs_Phone", pos: simd_float3(55.785,-0.70, 4.80), rotation: rotationMatrix, scale: simd_float3(6.4,6.4,6.4))
        let model16 = ModelAnchor(modelName: "qs_iBook", pos: simd_float3(55.785,17.269, 4.80), rotation: rotationMatrix, scale: simd_float3(60,60,60))
        let model17 = ModelAnchor(modelName: "qs_Weather", pos: simd_float3(63.1652,25.246, 0.7361), rotation: rotationMatrix, scale: simd_float3(6.3,6.3,6.3))
        let model18 = ModelAnchor(modelName: "qs_Safari", pos: simd_float3(63.165,-3.61, 0.73), rotation: rotationMatrix, scale: simd_float3(6.3,6.3,6.3))
         modelAnchorList = [model1, model2, model3, model4, model5,model6, model7,model8, model9,model10, model11, model12, model13, model14, model15, model16, model17, model18]



    }
    
    func getTransformedModelAnchors(poseARKitToW: simd_float4x4) -> [ModelAnchor]{
        var transformedModelAnchors  : [ModelAnchor] = []
        for anchor in modelAnchorList {
            var modelAnchor = getTransformedModelAnchor(modelAnchor: anchor, T_arkit_w: poseARKitToW)
            if modelAnchor.transform != nil {
                modelAnchor.anchorName =  AnchorIdentifierHelper.encode(userName: rootUserName, modelName: modelAnchor.modelName)
                transformedModelAnchors.append(modelAnchor)
            }
            print("modelAnchor\(modelAnchor.modelName) .transform \(modelAnchor.transform)")
            
        }
        return transformedModelAnchors
    }

}
