//
//  USDZModelManagerViewModel.swift
//  ACRT
//
//  Created by baochong on 2021/11/12.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation


class USDZManagerViewModel: ObservableObject {
    var exploreModelList : USDZModelList = USDZModelList(usdzModelNameList:  ["hello", "AppleLogo","Hello_World_Globe","Title","flight","gear","hammer","hand"])
    var createModelList : USDZModelList = USDZModelList(usdzModelNameList:["hello", "hello_1", "AppleHello", "AppleLogo","hand"])
    
    func AreModelLibrariesLoaded() -> Bool {
            return exploreModelList.AreModelsLoaded() && createModelList.AreModelsLoaded()
    }
    
}
