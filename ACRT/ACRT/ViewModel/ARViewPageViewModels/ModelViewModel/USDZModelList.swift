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


class USDZModelList {
    
    var usdzModelList : [USDZModel]
    
    init(usdzModelNameList: [String], categoryList: [ModelCategory]) {
        usdzModelList = []
        for index in 0..<usdzModelNameList.count {
            usdzModelList.append(USDZModel(modelName: usdzModelNameList[index], category: categoryList[index]))
        }
    }
    
    func get(category: ModelCategory) -> [USDZModel] {
        return usdzModelList.filter( {$0.category == category})
    }

}
