//
//  Updates.swift
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

struct Update: Hashable{
    let id = UUID()
    var imageName: String
    var updateTitle: String
    var updateTime: Date
    var details: String
    
    init(imageName: String, updateTitle: String, updateTime: String, details: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if let updateTimeChecked = formatter.date(from: updateTime){
            self.updateTime = updateTimeChecked
        }else{
            print("[error] Update time must conform type yyyy/MM/dd!")
            self.updateTime = Date()
        }
        self.imageName = imageName
        self.updateTitle = updateTitle
        self.details = details
    }
}
