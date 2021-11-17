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

enum ModelCategory: String, CaseIterable{
    case letter, foundmental, other
    
    var label: String{
        get{
            switch self{
            case .letter:
                return "Letters"
            case .foundmental:
                return "Foundmentals"
            case .other:
                return "Others"
            }
        }
    }
}

class USDZModel{
    var modelName: String
    var modelEntity: ModelEntity?
    var modelPreviewImage: UIImage?
    var category: ModelCategory
    
    private var cancellable: AnyCancellable? = nil
    
    
    init(modelName: String, category: ModelCategory){
        self.modelName = modelName
        self.category = category
        self.modelPreviewImage = UIImage(named: modelName)
//        let fileName = self.modelName+".usdz"
//
//        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
//            .sink(receiveCompletion : {loadCompletion in
//            }, receiveValue:{ modelEntity in
//                self.modelEntity = modelEntity
//            })
    }
    
    func asyncLoadModelEntity(handler : @escaping(_ completed : Bool, _ error: Error?)->Void) {
        let fileName = self.modelName+".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion : {loadCompletion in
                print("1")
                handler(false,nil)
            }, receiveValue:{modelEntity in
                
                handler(true,nil)
                self.modelEntity = modelEntity
            })
    }
}
