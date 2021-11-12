//
//  USDZViewModel.swift
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

struct ModelAnchor {
    var modelName : String
    var transform : simd_float4x4?  // T_x_model
    var anchorName : String?  // used for submit
    
    init(modelName: String, pos: simd_float3, rotation: simd_float3x3, scale: simd_float3) {
        self.modelName = modelName
        self.transform = getTransformMatrix(pos: pos, rotation: rotation, scale: scale)
        self.anchorName = nil
    }
    
    init(modelName: String, pos: simd_float3, rotation: simd_float3x3, scale: simd_float3,
         anchorName : String?) {
        self.modelName = modelName
        self.transform = getTransformMatrix(pos: pos, rotation: rotation, scale: scale)
        self.anchorName = anchorName
    }
    
    init(modelName: String, transform : simd_float4x4?,
         anchorName : String?){
        self.modelName = modelName
        self.transform = transform
        self.anchorName = anchorName
    }

}

func getTransformedModelAnchor(modelAnchor : ModelAnchor, T_arkit_w: simd_float4x4) -> ModelAnchor {
    guard let transform = modelAnchor.transform else {
        return ModelAnchor(modelName: modelAnchor.modelName, transform: nil, anchorName: modelAnchor.anchorName)
    }
    return ModelAnchor(modelName: modelAnchor.modelName, transform: T_arkit_w * transform, anchorName: modelAnchor.anchorName)
}

func getTransformMatrix(pos: simd_float3, rotation: simd_float3x3, scale: simd_float3) -> simd_float4x4 {
    var matrix = matrix_identity_float4x4
    for i in 0...2 {
        for j in 0...2 {
            matrix[i][j] = rotation[i][j] * scale[j]
        }
        matrix[3][i] = 0
        matrix[i][3] = pos[i]
    }
    matrix[3][3] = 1.0
    return matrix.transpose
}
