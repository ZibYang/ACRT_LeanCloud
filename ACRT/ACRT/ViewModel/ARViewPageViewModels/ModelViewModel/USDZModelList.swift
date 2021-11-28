//
//  USDZLibraryViewModel.swift
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
    case emoji, special, message, letter, foundmental
    
    var label: String{
        get{
            switch self{
            case .emoji:
                    return "Emoji"
            case .message:
                return "Messages"
            case .letter:
                return "Letters"
            case .foundmental:
                return "Foundmentals"
            case .special:
                return "Special Event"
            }
        }
    }
}

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

class USDZModelList {
    
    var usdzModelList : [USDZModel]
    var categoryList: [String: ModelCategory]
    var thumbnails: [String: UIImage?]

    
    init(usdzModelNameList: [String: ModelCategory], readThumbnails: Bool = false) {
        categoryList = usdzModelNameList
        usdzModelList = []
        thumbnails = [:]
        for item in usdzModelNameList {
            let model = USDZModel(modelName: item.key)
            usdzModelList.append(model)
            if readThumbnails == true {
                thumbnails[model.modelName] = UIImage(named: "sheet_"+model.getBodyOfModelName())
            }
        }
    }
    
//    func get(category: ModelCategory) -> [USDZModel] {
//        return usdzModelList.filter( {$0.category == category})
//    }
    
//    func getUSDZModelEntity(modelName: String) -> ModelEntity? {
//        if let model = usdzModelList.filter( {$0.modelName == modelName})[0].modelEntity {
//            return model
//        } else {
//            return nil
//        }
//    }
    
    func getUSDZModel(modelName: String) -> USDZModel? {
        for model in self.usdzModelList {
            if model.modelName == modelName {
                return model
            }
        }
        return nil
    }
    
    func AreModelsLoaded() -> Bool {
        for model in usdzModelList {
            if model.modelEntity == nil {
                print("model \(model.modelName) does not exist ")
                return false
            }
        }
        return true
    }
    
    func getModelNameByCategory(category: ModelCategory) -> [String] {
        return categoryList.allKeys(forValue: category).sorted()
    }
    
    func getThumbnail(modelName: String) -> UIImage? {
        let glyphIndex = thumbnails.firstIndex(where: { $0.key == modelName
        })
        if let index = glyphIndex {
            return thumbnails[index].value
        } else {
            print("DEBUG(BCH): missing \(modelName)")
            return nil
        }
    }
    
    

}
