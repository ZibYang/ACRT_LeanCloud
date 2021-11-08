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
    
    var arView: CustomARView

    var lastCameraPose: simd_float4x4 = simd_float4x4()
    var poseARKitToW: simd_float4x4 = simd_float4x4()
    let scale : Float = 1.0 //old qiushi : 6.7664; shelf : 0.21419, 1022qiushi: 3.34645, 1024:0.858995
    
    
    var isLiDAREqiped: Bool{
        return ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification)
    }
    
    init(){
        arView = CustomARView(frame: .zero)
        
        if isLiDAREqiped{
            capabilitySatisfied = "satisfied"
        }
    }
    
    func RequestLocalization(manager: HttpAuth) {
            let isGrayScale : Bool = true
            let useSensetime: Bool = true
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
        }
    
    func placeInherentARObjects(arObjectLibrary: ARObjectLibraryViewModel) {
        arObjectLibrary.updateInherentModels(poseARKitToW: poseARKitToW)
        arObjectLibrary.pushUSDZIntoAnchor()
        for model in arObjectLibrary.inherentModelList {
            if model.isAdded == true && model.isRendered == false {
                print("DEBUG(BCH) add model \(model.modelName) into arView")
                arView.scene.anchors.append(model.anchorModelEntity)
                model.isRendered = true
            }
        }
    }
        
        
}
