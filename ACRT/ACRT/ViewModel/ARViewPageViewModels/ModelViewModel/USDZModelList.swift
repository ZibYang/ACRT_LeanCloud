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
    case text, emoji, victory, special, message, letter, foundmental
    
    var label: String{
        get{
            switch self{
            case .text:
                return "MessageBoard"
            case .emoji:
                return "Emoji"
            case .victory:
                return "Victory"
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

struct ModelContrib {
    var model : USDZModel
    var modelCategory: ModelCategory
    var isVertcalToGround : Bool
    var thumbnail: UIImage?
    
    init(_ modelName: String, _ modelCategory: ModelCategory, isVertcalToGround: Bool, readThumbnail: Bool = false) {
        self.model = USDZModel(modelName: modelName)
        self.modelCategory = modelCategory
        self.isVertcalToGround = isVertcalToGround
        if readThumbnail == true {
            self.thumbnail = UIImage(named: "sheet_"+model.getBodyOfModelName())
        } else {
            self.thumbnail = nil
        }
    }
}

class USDZModelList {
    
    var usdzModelList : [String: ModelContrib]
    
//    init(usdzModelNameList: [String: ModelCategory], readThumbnails: Bool = false) {
//        categoryList = usdzModelNameList
//        usdzModelList = []
//        thumbnails = [:]
//        IsVerticalToGround = [:]
//        for item in usdzModelNameList {
//            let model = USDZModel(modelName: item.key)
//            usdzModelList.append(model)
//            if readThumbnails == true {
//                thumbnails[model.modelName] = UIImage(named: "sheet_"+model.getBodyOfModelName())
//            }
//            IsVerticalToGround[item.key] = true
//        }
//    }
    
    init(usdzModelList: [ModelContrib]) {
        self.usdzModelList=[:]
        for modelContrib in usdzModelList {
            self.usdzModelList[modelContrib.model.modelName] = modelContrib
        }
    }
    

    
    func getUSDZModel(modelName: String) -> USDZModel? {
        let glyphIndex = usdzModelList.firstIndex(where: { $0.key == modelName
        })
        if let index = glyphIndex {
            return usdzModelList[index].value.model
        } else {
            print("DEBUG(BCH): missing \(modelName)")
            return nil
        }
    }
    
    func loadModelEntities() {
        for (modelName, modelContrib) in usdzModelList {
            modelContrib.model.asyncLoadEntity(){ completed, error in
                if completed {
                    print("DEBUG(BCH): explore load \(modelName) sucessfully")
                }
            }
        }
    }
    
    
    func AreModelsLoaded() -> Bool {
        for (modelName, modelContrib) in usdzModelList {
            if modelContrib.model.modelEntity == nil {
                print("model \(modelName) does not exist ")
                return false
            }
        }
        return true
    }
    
    func getModelNameByCategory(category: ModelCategory) -> [String] {
        var selectedNames : [String] = []
        for (modelName, modelContrib) in usdzModelList {
            if modelContrib.modelCategory == category {
                selectedNames.append(modelName)
            }
        }
        return selectedNames.sorted()
    }
    
    func getThumbnail(modelName: String) -> UIImage? {
        let glyphIndex = usdzModelList.firstIndex(where: { $0.key == modelName
        })
        if let index = glyphIndex {
            return usdzModelList[index].value.thumbnail
        } else {
            print("DEBUG(BCH): missing \(modelName)")
            return nil
        }
    }
    
    func isModelVerticalToGround(modelName: String) -> Bool {
        let glyphIndex = usdzModelList.firstIndex(where: { $0.key == modelName
        })
        if let index = glyphIndex {
            return usdzModelList[index].value.isVertcalToGround
        } else {
            print("DEBUG(BCH): missing \(modelName)")
            return false
        }
    }
    
    

}
