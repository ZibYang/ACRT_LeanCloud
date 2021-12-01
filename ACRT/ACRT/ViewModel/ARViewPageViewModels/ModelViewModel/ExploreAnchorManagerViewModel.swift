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
        let model1 = ModelAnchor(modelName: "AppleLogo.usdz", pos: simd_float3(-4.87282, -16.316, 23.8932), rotation: rotationMatrix, scale: simd_float3(4,4,4))
        modelAnchorList = [model1]
    }
    
    func initializeInherentModelsQiuShi() {
        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
        let worldFront = simd_float3(0,0,-1) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        //Qiushi
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))

        let model1 = ModelAnchor(modelName: "qs_AppStore.usdz", pos: simd_float3(0.35, -0.9024, 4.4489), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model2 = ModelAnchor(modelName: "qs_AppleLogo_right.usdz", pos: simd_float3(7.4656, -3.0853, 6.3871), rotation: rotationMatrix, scale: simd_float3(50,50,50))
        let model3 = ModelAnchor(modelName: "qs_AppleLogo_left.usdz", pos: simd_float3(15.4656, -3.085,6.3871), rotation: rotationMatrix, scale: simd_float3(1,1,1))
        let model4 = ModelAnchor(modelName: "qs_AppleMusic.usdz", pos: simd_float3(18.1737, -7.88608, 14.1996), rotation: rotationMatrix, scale: simd_float3(40,40,40))
        let model5 = ModelAnchor(modelName: "qs_Calendar.usdz", pos: simd_float3(20.559, -1.39, 2.754), rotation: rotationMatrix, scale: simd_float3(40,40,40))
        let model6 = ModelAnchor(modelName: "qs_Hello.usdz", pos: simd_float3(12.1793, -1.3317, 8.66942), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model7 = ModelAnchor(modelName: "Title.usdz", pos: simd_float3(12.5103, -7.78159, 6.9709), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model8 = ModelAnchor(modelName: "qs_Camera.usdz", pos: simd_float3(8.61513, -7.44404, 14.6042), rotation: rotationMatrix, scale: simd_float3(8,8,8))
        let model9 = ModelAnchor(modelName: "qs_Hello.usdz", pos: simd_float3(-8.03984, -2.56496, 9.19537), rotation: rotationMatrix, scale: simd_float3(15,15,15))
        let model10 = ModelAnchor(modelName: "qs_SwiftChangeTheWorld.usdz", pos: simd_float3(33.907, -2.3223, 7.93072), rotation: rotationMatrix, scale: simd_float3(4,4,4))
        modelAnchorList = [model1, model2, model3, model4, model5,model6, model7,model8, model9, model10]
    
    }
    
    func initializeInherentModelsShelf()  {
        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
        let worldFront = simd_float3(0,0,-1) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))

            //Shelf
        let model1 = ModelAnchor(modelName: "qs_Hello.usdz", pos: simd_float3(0.341545, -0.727689, 5.92317), rotation: rotationMatrix, scale: simd_float3(10.0, 10.0, 10.0))
    
        let model2 = ModelAnchor(modelName: "qs_AppleLogo_left.usdz", pos: simd_float3(-3.38882, 0.0870665, 0.155429), rotation: rotationMatrix, scale: simd_float3(1, 1, 1))
        
        let model3 = ModelAnchor(modelName: "qs_AppleLogo_right.usdz", pos: simd_float3(-7.73664609,  0.536159  , -4.19239709), rotation: rotationMatrix, scale: simd_float3(100, 100, 100))
    
//            let model3 = ModelAnchor(modelName: "AppleLogo.usdz", pos: simd_float3(4.05483, 0.582852, 0.191444), rotation: rotationMatrix, scale: simd_float3(0.4,0.4,0.4))
            
        modelAnchorList = [model1, model2, model3]
    }
    
    func initializeInherentModelsQiuShiSensetime() {
        let worldUp1 =  simd_float3(0,0,1) // = local y in world axis
        let worldFront1 = simd_float3(1,0,0) // = local z in world axis
        let worldRight1 = normalize(cross(-1 * worldUp1, -1 * worldFront1))
        //Qiushi
        let rotationMatrix1 : simd_float3x3 = simd_float3x3(columns:(worldRight1, worldUp1, worldFront1))
        
        let worldUp2 =  simd_float3(1,0,0) // = local y in world axis
        let worldFront2 = simd_float3(0,0,-1) // = local z in world axis
        let worldRight2 = normalize(cross(worldUp2, worldFront2))
        let rotationMatrix2 : simd_float3x3 = simd_float3x3(columns:(worldRight2, worldUp2, worldFront2))

        let model1 = ModelAnchor(modelName: "qs_AppStore.usdz", pos: simd_float3(62.734833, -1.281104, -0.013874), rotation: rotationMatrix1, scale: simd_float3(30,30,30))
        let model2 = ModelAnchor(modelName: "qs_AppleLogo_right.reality", pos: simd_float3(60.134, 3.7623, 1.928), rotation: rotationMatrix2, scale: simd_float3(1.5,1.5,1.5))
        let model3 = ModelAnchor(modelName: "qs_AppleLogo_left.reality", pos: simd_float3(60.406, 13.3623, 1.928), rotation: rotationMatrix2, scale: simd_float3(1.2,1.2,1.2))
         let model4 = ModelAnchor(modelName: "qs_AppleMusic.usdz", pos: simd_float3(57.474, 13.969, 5.5088), rotation: rotationMatrix1, scale: simd_float3(60,60,60))
         let model5 = ModelAnchor(modelName: "qs_Calendar.usdz", pos: simd_float3(65.32, 18.528, 0.0), rotation: rotationMatrix1, scale: simd_float3(40,40,40))
         let model6 = ModelAnchor(modelName: "qs_Hello.usdz", pos: simd_float3(60.135, 9.017, 1), rotation: rotationMatrix1, scale: simd_float3(10,10,10))
         let model7 = ModelAnchor(modelName: "qs_Title.reality", pos: simd_float3(55.291, 9.056, 9.2607), rotation: rotationMatrix2, scale: simd_float3(3,3,3))
        let model8 = ModelAnchor(modelName: "qs_Camera.usdz", pos: simd_float3(55.046, 4.223, 6.4), rotation: rotationMatrix1, scale: simd_float3(12,12,12))
         let model9 = ModelAnchor(modelName: "qs_Swift.usdz", pos: simd_float3(60.92, -9, 2.27), rotation: rotationMatrix1, scale: simd_float3(15,15,15))
         let model10 = ModelAnchor(modelName: "qs_SwiftChangeTheWorld.usdz", pos: simd_float3(60.92, 31.17, 2.27), rotation: rotationMatrix1, scale: simd_float3(4,4,4))
        let model11 = ModelAnchor(modelName: "qs_Facetime.usdz", pos: simd_float3(56.0926, -3.03, 2.27), rotation: rotationMatrix1, scale: simd_float3(6.3,6.3,6.3))
        let model12 = ModelAnchor(modelName: "qs_Health.usdz", pos: simd_float3(56.0926, 19.03, 2.27), rotation: rotationMatrix1, scale: simd_float3(6.3, 6.3, 6.3))
        let model13 = ModelAnchor(modelName: "qs_Home.usdz", pos: simd_float3(67.41,14.31, -0.86), rotation: rotationMatrix1, scale: simd_float3(6.3,6.3,6.3))
        let model14 = ModelAnchor(modelName: "qs_iMessage.usdz", pos: simd_float3(67.41,3.08, -0.86), rotation: rotationMatrix1, scale: simd_float3(6.3, 6.3, 6.3))
        let model15 = ModelAnchor(modelName: "qs_Phone.usdz", pos: simd_float3(55.785,-0.70, 4.80), rotation: rotationMatrix1, scale: simd_float3(6.4,6.4,6.4))
        let model16 = ModelAnchor(modelName: "qs_iBook.usdz", pos: simd_float3(55.785,17.269, 4.80), rotation: rotationMatrix1, scale: simd_float3(60,60,60))
        let model17 = ModelAnchor(modelName: "qs_Weather.usdz", pos: simd_float3(63.1652,25.246, 0.7361), rotation: rotationMatrix1, scale: simd_float3(6.3,6.3,6.3))
        let model18 = ModelAnchor(modelName: "qs_Safari.usdz", pos: simd_float3(63.165,-3.61, 0.73), rotation: rotationMatrix1, scale: simd_float3(6.3,6.3,6.3))
        let model19 = ModelAnchor(modelName: "qs_findMy.usdz", pos: simd_float3(56.577, 10.920, 2.4175), rotation: rotationMatrix1, scale: simd_float3(6.3,6.3,6.3))
        let model20 = ModelAnchor(modelName: "qs_contacts.usdz", pos: simd_float3(56.577, 6.1602, 2.4175), rotation: rotationMatrix1, scale: simd_float3(6.3,6.3,6.3))
//        let model21 = ModelAnchor(modelName: "qs_AppleLogo_center.usdz", pos: simd_float3(70.916, 8.4716, -1.1063), rotation: rotationMatrix1, scale: simd_float3(0.4,0.4,0.4))
        let model21 = ModelAnchor(modelName: "qs_AppleLogo_center.usdz", pos: simd_float3(55.291, 3.056, 9.7607), rotation: rotationMatrix1, scale: simd_float3(0.8,0.8,0.8))
        let model22 = ModelAnchor(modelName: "qs_zjuLogo.usdz", pos: simd_float3(55.291, 15.056, 8.7607), rotation: rotationMatrix1, scale: simd_float3(10,10,10))


        modelAnchorList = [model1, model2, model3, model4, model5,model6, model7,model8, model9,model10, model11, model12, model13, model14, model15, model16, model17, model18, model19, model20, model21,model22]



    }
    
    func getTransformedModelAnchors(poseARKitToW: simd_float4x4) -> [ModelAnchor]{
        var transformedModelAnchors  : [ModelAnchor] = []
        for anchor in modelAnchorList {
            var modelAnchor = getTransformedModelAnchor(modelAnchor: anchor, T_arkit_w: poseARKitToW)
            if modelAnchor.transform != nil {
                modelAnchor.anchorName =  AnchorIdentifierHelper.encode(userName: rootUserName, modelName: modelAnchor.model.modelName)
                transformedModelAnchors.append(modelAnchor)
            }
            print("modelAnchor\(modelAnchor.model.modelName) .transform \(modelAnchor.transform)")
            
        }
        return transformedModelAnchors
    }

}
