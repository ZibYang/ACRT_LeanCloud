//
//  PlacementSetting.swift
//  FocusEntityPlacer
//
//  Created by baochong on 2021/11/5.
//

import Foundation
import Combine
import ARKit

class PlacementSetting  : ObservableObject {
    
    var sceneObserver: Cancellable?
    var modelConfirmedForPlacement: [ModelAnchor] = []
    @Published var selectedModel: String? {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue))")
        }
    }
    @Published var readyToPlace : Bool  = false
    @Published var isInCreationMode : Bool = false
    @Published var openModelList = false
    
    init() {
        selectedModel = "hello"
    }
    


}
