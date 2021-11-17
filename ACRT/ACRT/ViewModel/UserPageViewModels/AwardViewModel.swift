//
//  AwardViewModel.swift
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

let specialEventAwardName = ["MAIC"]
let specialEventAwardDetail = ["MAIC!"]

let dailyEventAwardName = ["Owl", "Morning"]
let dailyEventAwardDetail = ["Don't stay up too late!","Have a good morning!"]

let landmarkAwardName = ["Hangzhou", "Shanghai", "Beijing", "Guangzhou", "Shenzhen", "Chengdu", "Nanjing", "Apple"]
let landmarkAwardDetail = ["Welcome to HangZhou", "Welcome to ShangHai", "Welcome to Beijing", "Welcome to Guangzhou", "Welcome to Shenzhen", "Welcome to Chengdu",  "Welcome to Nanjing", "OMG!You are visiting Apple Park!"]

class AwardModel: ObservableObject{
    @Published var specialEventAward: [Award]
    @Published var dailyEventAward: [Award]
    @Published var landmarkAward: [Award]
    
    init(){
        // MARK: specialEventAward
        specialEventAward = []
        // MARK: LandMarkAward
        landmarkAward = []
        // MARK: dailyEventAward
        dailyEventAward = []
        
        for i in 0..<specialEventAwardName.count{
            specialEventAward.append(Award(name: specialEventAwardName[i], detail: specialEventAwardDetail[i]))
        }
        for i in 0..<dailyEventAwardName.count{
            dailyEventAward.append(Award(name: dailyEventAwardName[i], detail: dailyEventAwardDetail[i]))
        }
        for i in 0..<landmarkAwardName.count{
            landmarkAward.append(Award(name: landmarkAwardName[i], detail: landmarkAwardDetail[i]))
        }
    }
}


