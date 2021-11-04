//
//  ARViewModel.swift
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

import Foundation
import RealityKit
import SwiftUI
import ARKit


class ARViewModel: ObservableObject{
    @Published var capabilitySatisfied = "optional"
    //MARK: For prepareView
    let indicatorImageName = "LiDARRequire"
    let indicatorTitle = "Use Device with LiDAR"
    let indicatorDescription = "LiDAR enhance the ability of realized the world."
    
    var arView: ARView

    var lastCameraPose: simd_float4x4 = simd_float4x4()
    
    var poseARKitToW: simd_float4x4 = simd_float4x4()
    
    let scale : Float = 1.0 //old qiushi : 6.7664; shelf : 0.21419, 1022 qiushi: 3.34645, 1024:0.858995
        
    var modelList : [USDZViewModel] = []
    
    var isLiDAREqiped: Bool{
        return ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification)
    }
    
    init(){
        arView = ARView(frame: .zero)
        
        if isLiDAREqiped{
            capabilitySatisfied = "satisfied"
        }
    }
    
    func RequestLocalization(manager: HttpAuth) {
            let isGrayScale : Bool = true
            let useSensetime: Bool = false
            let locIntime: Bool = false
            
            guard let arFrame = arView.session.currentFrame else {
                print("Warning: current frame is nil")
                return
            }
            
            let imageBuffer = arFrame.capturedImage
            
            var intrinsic = arFrame.camera.intrinsics
            lastCameraPose = arView.cameraTransform.matrix
            

            var image = pixelBufferToUIImage(pixelBuffer: imageBuffer)
            if image == nil  {
                print("Warning: conversion from pixelBuffer to uiimage fails")
                return
            }
            var orient : UIInterfaceOrientation?
            DispatchQueue.main.sync {
                orient = UIApplication.shared.statusBarOrientation
            }
            if orient == UIInterfaceOrientation.portrait {
                print("DEBUG(BCH): rotate image")
                guard let result = rotateImage(image: image!, intrinsic: intrinsic) else {
                        print("Warning: rotation failed")
                        return
                }
                image = result.image
                intrinsic = result.intrinsic
            }
           
            guard let image = image else {
                print("Warning: image is nil")
                return
            }

            if(useSensetime == true) {
                print("DEBUG(BCH): Sensetime request")
                guard let strBase64 = processImage(image: image, isGrayscale: isGrayScale, useRawData: true) else {
                    print("Warning: processing image fails")
                    return
                }
                manager.querySensetimeOnline(url: manager.qiuShiUrlSensetime, strBase64: strBase64, width: Int(image.size.width), height: Int(image.size.height), intrinsic: intrinsic)
            }
            else{
                print("DEBUG(BCH): Hloc request")
                let useRawData : Bool = true
                guard let strBase64 = processImage(image: image, isGrayscale: isGrayScale, useRawData: useRawData) else {
                    print("Warning: processing image fails")
                    return
                }
                var url : String
                if(locIntime == true) {
                    url = manager.inTimeUrl
                } else {
                    url = manager.qiuShiUrl
                }
                manager.queryOnline(url: url,strBase64: strBase64, width: Int(image.size.width), height: Int(image.size.height), intrinsic: intrinsic, isGrayScale:isGrayScale, useRawData:useRawData, extrinsic: lastCameraPose)
            }
        }
        
        func onLocalizationResult(manager: HttpAuth) {
            let srtARKitCToC: simd_float4x4 = simd_float4x4(simd_float4(scale,  0.000,   0.00,    0.0),
                                            simd_float4(0.000,     -scale,   0.00,   0.000),
                                            simd_float4(0.00,  0.00,   -scale,    0.0),
                                               simd_float4(0.0, 0.0, 0.0, 1.0)).transpose
            poseARKitToW = lastCameraPose * srtARKitCToC * manager.T_ci_w
            print("DEBUG(BCHO): poseARKitToW", poseARKitToW)
            print("DEBUG(BCHO): srtARKitCToC", srtARKitCToC)
            print("DEBUG(BCHO): lastCameraPose", lastCameraPose)


            placeObj()

        }
        
        func initializeModels() -> [USDZViewModel] {
    //        let worldUp =  simd_float3(0,-1,0) // = local y in world axis
    //        let worldFront = simd_float3(0,0,-1) // = local z in world axis
    //        let worldRight = normalize(cross(-1 * worldUp, -1 * worldFront))
    // Qiushi
    //        let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
    //        let model1 = USDZViewModel(modelName: "hello", worldPos: simd_float3(12.4161, -1.48313, 9.02723), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))
    //
    //        let model2 = USDZViewModel(modelName: "AppleLogo", worldPos: simd_float3(-8.45376, -2.92693, 9.33032), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))
    //
    //        let model3 = USDZViewModel(modelName: "AppleLogo", worldPos: simd_float3(33.3995, -2.83004, 7.99316), worldRotation: rotationMatrix, worldScale: simd_float3(1,1,1))
    //Shelf
    //        let model1 = USDZViewModel(modelName: "hello", worldPos: simd_float3(0.341545, -0.727689, 5.92317), worldRotation: rotationMatrix, worldScale: simd_float3(0.2,0.2,0.2))
    //
    //        let model2 = USDZViewModel(modelName: "AppleLogo", worldPos: simd_float3(-3.38882, 0.0870665, 0.155429), worldRotation: rotationMatrix, worldScale: simd_float3(0.4,0.4,0.4))
    //
    //        let model3 = USDZViewModel(modelName: "AppleLogo", worldPos: simd_float3(4.05483, 0.582852, 0.191444), worldRotation: rotationMatrix, worldScale: simd_float3(0.4,0.4,0.4))
            
    //        return [model1, model2, model3]
    //InTime
            let worldUp =  simd_float3(0,-1,0) // = local y in world axis
            let worldFront = simd_float3(-0.94613601,  0.26701994, -0.18310379) // = local z in world axis
            let worldRight = normalize(cross(worldUp, worldFront))
            let rotationMatrix : simd_float3x3 = simd_float3x3(columns:(worldRight, worldUp, worldFront))
            let model1 = USDZViewModel(modelName: "AppleLogo", worldPos: simd_float3(-4.87282, -16.316, 23.8932), worldRotation: rotationMatrix, worldScale: simd_float3(4,4,4))

            return [model1]

        }
        
        func placeObj() {
            for model in modelList {
                print("DEBUG(BCH) test model ", model.modelName)
                if let usdzEntity = model.usdzModel.modelEntity {
                    model.updateModelTransform(T_arkit_w: poseARKitToW)
                    print("DEBUG(BCH) update model ", model.modelName)
                    if model.isAdded == false {
                        print("DEBUG(BCH) added pos ", model.anchorModelEntity.transform.translation)
                        model.anchorModelEntity.addChild(usdzEntity.clone(recursive: true))
                        arView.scene.anchors.append(model.anchorModelEntity)
                        model.isAdded = true
                    }
                }

            }
            
        }
}
