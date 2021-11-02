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
    
    let scale : Float = 0.21419 //shelf : 0.21419 ;  qiushi_ipad : 6.7664
    
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
        guard let imageBuffer = arView.session.currentFrame?.capturedImage else {
            print("Warning: current frame is nil")
            return
        }
        guard let intrinsic = arView.session.currentFrame?.camera.intrinsics else {
            print("Warning: current frame is nil")
            return
        }
        guard let image = UIImage(pixelBuffer: imageBuffer) else {
            print("Warning: converting image buffer to UIImage failed")
            return
        }

        lastCameraPose = arView.cameraTransform.matrix
        manager.queryOnline(image: image, intrinsic: intrinsic, extrinsic: lastCameraPose)
    }
    
    func onLocalizationResult(manager: HttpAuth) {
        let srtARKitCToC: simd_float4x4 = simd_float4x4(
            simd_float4(scale,  0.000,   0.00,    0.0),
            simd_float4(0.000,     -scale,   0.00,   0.000),
            simd_float4(0.00,  0.00,   -scale,    0.0),
            simd_float4(0.0, 0.0, 0.0, 1.0)).transpose
        poseARKitToW = lastCameraPose * srtARKitCToC * manager.T_ci_w
        print("DEBUG(BCHO): poseARKitToW", poseARKitToW)
    }
}
