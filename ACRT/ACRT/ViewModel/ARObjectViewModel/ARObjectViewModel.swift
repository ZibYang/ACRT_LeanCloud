//
//  USDZViewModel.swift
//  ACRT
//
//  Created by baochong on 2021/10/29.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation
import RealityKit

class ARObjectViewModel {
    var modelName : String
    var anchorModelEntity: AnchorEntity
    var worldPos : simd_float3
    var worldRotation : simd_float3x3
    var worldScale : simd_float3
    var worldTransform : simd_float4x4  // T_w_model
    var isAdded: Bool
    var isRendered : Bool
    
    init(modelName: String, worldPos: simd_float3, worldRotation: simd_float3x3, worldScale: simd_float3) {
        self.modelName = modelName
        self.anchorModelEntity = AnchorEntity(world: SIMD3(x:0, y:0, z:0))
        self.worldPos = worldPos
        self.worldRotation = worldRotation
        self.worldScale = worldScale
        self.worldTransform = matrix_identity_float4x4
        isAdded = false
        isRendered = false
    }

    
    func updateModelTransform(T_arkit_w: simd_float4x4) {
        var arkitPosHomo = simd_float4(self.worldPos[0] ,self.worldPos[1],self.worldPos[2], 1)
        arkitPosHomo = T_arkit_w * arkitPosHomo
        print("DEBUG(BCHO) arkit pos homo", arkitPosHomo)

        let arkitPos = simd_float3(arkitPosHomo[0]/arkitPosHomo[3], arkitPosHomo[1]/arkitPosHomo[3], arkitPosHomo[2]/arkitPosHomo[3])
        
        var arkitRotation = matrix_identity_float3x3
        for i in 0..<3 {
            var arkitAxis = simd_float4(self.worldRotation[i,0], self.worldRotation[i,1],
                                        self.worldRotation[i,2], 0)
            arkitAxis = T_arkit_w * arkitAxis
            arkitRotation[i,0] = arkitAxis[0]
            arkitRotation[i,1] = arkitAxis[1]
            arkitRotation[i,2] = arkitAxis[2]
        }
        print("DEBUG(BCHO) arkit pos ", arkitPos)
        anchorModelEntity.transform.translation = arkitPos
        anchorModelEntity.transform.rotation = simd_quatf(arkitRotation)
        anchorModelEntity.transform.scale = worldScale
    }
    
    
    
}
