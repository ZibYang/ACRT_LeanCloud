//
//  USDZLibraryViewModel.swift
//  ACRT
//
//  Created by baochong on 2021/11/3.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import UIKit
import Foundation
import RealityKit
import Combine


class USDZModelList {
    
    var usdzModelList : [String : USDZModel]
    
    init(usdzModelNameList: [String]) {
        usdzModelList = [String: USDZModel]()
        for name in usdzModelNameList {
            usdzModelList[name] = USDZModel(modelName: name)
        }
    }
    
    func getUSDZModelEntity(modelName: String) -> ModelEntity? {
        if usdzModelList.keys.contains(modelName){
            if let model = usdzModelList[modelName] {
                if model.modelEntity != nil  {
                    return model.modelEntity
                }
            }
        }
        return nil
    }
    
    func AreModelsLoaded() -> Bool {
        for (_, model) in usdzModelList {
            if model.modelEntity == nil {
                return false
            }
        }
        return true
    }

}
