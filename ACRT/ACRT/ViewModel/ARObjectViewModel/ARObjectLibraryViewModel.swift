//
//  USDZLibraryViewModel.swift
//  ACRT
//
//  Created by baochong on 2021/11/3.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation
import RealityKit

class ARObjectLibraryViewModel : ObservableObject {
    
    var inherentModelList : [ARObjectViewModel] = []
    var usdzInerentModelList : USDZLibraryViewModel = USDZLibraryViewModel(usdzModelNameList:  ["hello", "AppleLogo","Hello_World_Globe","Title","flight","gear","hammer","hand"])
    var usdzCreativeModelList : USDZLibraryViewModel = USDZLibraryViewModel(usdzModelNameList:["hello", "hello_1", "AppleHello", "AppleLogo"])

    
    init() {
//        initializeInherentModelsQiuShiSensetime()
        initializeInherentModelsShelf()
    }
    
    func initializeInherentModelsInTime() {
        //InTime
        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
        let worldFront = simd_float3(-0.94613601,  0.26701994, -0.18310379) // = local z in world axis
        let worldRight = normalize(cross(worldUp, worldFront))
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
        let model1 = ARObjectViewModel(modelName: "AppleLogo", worldPos: simd_float3(-4.87282, -16.316, 23.8932), worldRotation: rotationMatrix, worldScale: simd_float3(4,4,4))
        inherentModelList = [model1]
    }
    
    func initializeInherentModelsQiuShi() {
        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
        let worldFront = simd_float3(0,0,-1) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        //Qiushi
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
        let model1 = ARObjectViewModel(modelName: "Hello_World_Globe", worldPos: simd_float3(12.4161, -2.48313, 9.02723), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))

        let model2 = ARObjectViewModel(modelName: "AppleLogo", worldPos: simd_float3(-8.45376, -2.92693, 9.33032), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))

        let model3 = ARObjectViewModel(modelName: "AppleLogo", worldPos: simd_float3(33.3995, -2.83004, 7.99316), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))
        
        let model4 = ARObjectViewModel(modelName: "Title", worldPos: simd_float3(112.4831, -7.83952, 13.8966), worldRotation: rotationMatrix, worldScale: simd_float3(20,20,20))
        
        let model5 = ARObjectViewModel(modelName: "flight", worldPos: simd_float3(-0.822067, -9.01792, 11.3803), worldRotation: rotationMatrix, worldScale: simd_float3(10,10,10))
        
        let model6 = ARObjectViewModel(modelName: "gear", worldPos: simd_float3(25.6591, -8.51259, 10.7296), worldRotation: rotationMatrix, worldScale: simd_float3(10,10,10))
        
        let model7 = ARObjectViewModel(modelName: "hammer", worldPos: simd_float3(1.90713, -0.380037, 2.17264), worldRotation: rotationMatrix, worldScale: simd_float3(10,10,10))
        
        let model8 = ARObjectViewModel(modelName: "SwiftChangeTheWorld.usdz", worldPos: simd_float3(22.2034, -0.347333, 1.56218), worldRotation: rotationMatrix, worldScale: simd_float3(10,10,10))
        
        
        inherentModelList = [model1, model2, model3, model4, model5, model6, model7, model8]

    }
    
    func initializeInherentModelsShelf()  {
            let worldUp =  simd_float3(0,-1,0) // = local y in world axis
            let worldFront = simd_float3(0,0,-1) // = local z in world axis
            let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
            let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))

            //Shelf
            let model1 = ARObjectViewModel(modelName: "hello", worldPos: simd_float3(0.341545, -0.727689, 5.92317), worldRotation: rotationMatrix, worldScale: simd_float3(0.2,0.2,0.2))
    
            let model2 = ARObjectViewModel(modelName: "AppleLogo", worldPos: simd_float3(-3.38882, 0.0870665, 0.155429), worldRotation: rotationMatrix, worldScale: simd_float3(0.4,0.4,0.4))
        
        let model3 = ARObjectViewModel(modelName: "AppleLogo", worldPos: simd_float3(-7.73664609,  0.536159  , -4.19239709), worldRotation: rotationMatrix, worldScale: simd_float3(0.4,0.4,0.4))
    
//            let model3 = ARObjectViewModel(modelName: "AppleLogo", worldPos: simd_float3(4.05483, 0.582852, 0.191444), worldRotation: rotationMatrix, worldScale: simd_float3(0.4,0.4,0.4))
            
        inherentModelList = [model1, model2, model3]
    }
    
    func initializeInherentModelsQiuShiSensetime() {
        let worldUp =  simd_float3(0,0,1) // = local y in world axis
        let worldFront = simd_float3(1,0,0) // = local z in world axis
        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
        //Qiushi
        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
        let model1 = ARObjectViewModel(modelName: "hello", worldPos: simd_float3(59.538483, 9.173322, 0.584023), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))

        let model2 = ARObjectViewModel(modelName: "AppleLogo", worldPos: simd_float3(59.506565, 30.814552, 1.062348), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))

        let model3 = ARObjectViewModel(modelName: "AppleLogo", worldPos: simd_float3(59.398548, -11.554224, 1.109176), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))
        inherentModelList = [model1, model2, model3]

    }
    
    func updateInherentModels(poseARKitToW: simd_float4x4) {
        for model in inherentModelList {
            print("DEBUG(BCH) update pos ", model.anchorModelEntity.transform.translation)
            model.updateModelTransform(T_arkit_w: poseARKitToW)
        }
    }
    
    func pushUSDZIntoAnchor() {
        for model in inherentModelList {
            print("DEBUG(BCH) test model \(model.modelName)")
            if model.isAdded == false {
                if let usdzEntity = usdzInerentModelList.getUSDZModelEntity(modelName: model.modelName) {
                    model.anchorModelEntity.addChild(usdzEntity.clone(recursive: true))
                    model.isAdded = true
                }
            }

        }
    }
    
    func AreModelLibrariesLoaded() -> Bool {
        return usdzInerentModelList.AreModelsLoaded() && usdzCreativeModelList.AreModelsLoaded()
    }

}
