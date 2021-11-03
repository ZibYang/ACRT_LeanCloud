//
//  USDZModel.swift
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

import UIKit
import Foundation
import RealityKit
import Combine

class USDZModel1{
    var modelName: String
    var modelEntity: ModelEntity?
    private var cancellable: AnyCancellable? = nil
    
    
    init(modelName: String){
        self.modelName = modelName
        let fileName = self.modelName+".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion : {loadCompletion in
                print("1")
            }, receiveValue:{modelEntity in
                self.modelEntity = modelEntity
            })
    }
}
