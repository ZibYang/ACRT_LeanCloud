//
//  PlacementSetting.swift
//  FocusEntityPlacer
//
//  Created by baochong on 2021/11/5.
//

import Foundation
import Combine


class PlacementSetting  : ObservableObject {
    var sceneObserver: Cancellable?
    var confirmedModel : USDZModel?

    @Published var isInCreationMode = false
    @Published var openModelList = false
    
    var doPlaceModel : Bool  = false
    
    init() {
        confirmedModel = USDZModel(modelName: "hello")
    }

}
