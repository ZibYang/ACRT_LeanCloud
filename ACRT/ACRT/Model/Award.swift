//
//  Awards.swift
//  ACRT_new

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/5.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

import SwiftUI
import Foundation

struct Award: Identifiable{
    let id = UUID()
    let awardName: String
    let awardDetail: String
    
    var granted: Bool
    var grantedTime: Date?
    
    var timeDisplay: String{
        if granted{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            return dateFormatter.string(from: grantedTime!)
        }else{
            return "[Error] Not been granted yet"
        }
    }
    
    init(name: String, detail: String){
        granted = false
        self.awardName = name
        self.awardDetail = detail
    }
    
    func state() -> Bool{
        return granted
    }
}

