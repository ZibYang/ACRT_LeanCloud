//
//  PlacementSetting.swift
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
import Combine
import ARKit

class PlacementSetting : ObservableObject {
    
    var sceneObserver: Cancellable?
    var modelWaitingForPlacement: [ModelAnchor] = []
    var modelConfirmedForPlacement: [ModelAnchor] = []
    
    @Published var selectedModel: String {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue))")
        }
    }
    @Published var readyToPlace : Bool  = false
    @Published var isInCreationMode : Bool = false
    @Published var openModelList = false
    
    init() {
        selectedModel = ""
    }
    
    func place(radian : Float, axis: simd_float3) {
        let transform: simd_float4x4 = float4x4(simd_quatf(angle: radian , axis: axis))
        let modelAnchor = ModelAnchor(modelName: self.selectedModel, transform: transform, anchorName: nil)
        print("DEBUG(BCH): append \(modelAnchor.model.modelName)")

        self.modelWaitingForPlacement.append(modelAnchor)
//                        self.placementSetting.selectedModel = nil
    }
    


}
