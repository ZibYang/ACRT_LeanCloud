//
//  WhatIsNewViewModel.swift
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

class WhatIsNewViewModel{
    var updates: [Update]
    
    init(update: [Update]){
        updates = update
    }
}

var whatIsNew = WhatIsNewViewModel(update: [Update(imageName: "update5",
                                                   updateTitle: "MAIC 2021",
                                                   updateTime: "2021/10/29",
                                                   details: "Come and join the 6th MAIC match in Zhejiang University!"),
                                            Update(imageName: "update4",
                                                   updateTitle: "Apple Park",
                                                   updateTime: "2021/10/20",
                                                   details: "Wish we can meet in Apple Park one day."),
                                            Update(imageName: "update3",
                                                   updateTitle: "City Badges",
                                                   updateTime: "2021/10/18",
                                                   details: "Welcome to the historical Nanjin and Chendu."),
                                            Update(imageName: "update2",
                                                   updateTitle: "City Badges",
                                                   updateTime: "2021/10/15",
                                                   details: "Welcome to the beautiful Shenzhen and Guangzhou."),
                                            Update(imageName: "update1",
                                                   updateTitle: "City Badges",
                                                   updateTime: "2021/10/11",
                                                   details: "We have launched the first batch of 3 city badges!")])
