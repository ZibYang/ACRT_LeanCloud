//
//  AwardViewModel.swift
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

import SwiftUI
import Foundation
import LeanCloud

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
        
        if let user = LCApplication.default.currentUser{
            let query = LCQuery(className: "Award")
            query.whereKey("belongsTo", .equalTo(user))
            _ = query.find { result in
                switch result{
                case .success(objects: let awardList):
                    // This operation don't need network
                    for award in awardList{
                        print(award)
                        }

                case .failure(error: let error):
                    print(error)
                }
            }
        }
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        for i in 0..<specialEventAwardName.count{
            var item = Award(name: specialEventAwardName[i], detail: specialEventAwardDetail[i])
            item.granted.toggle()
            item.grantedTime = df.date(from: "2021-12-10")
            specialEventAward.append(item)
        }
        for i in 0..<dailyEventAwardName.count{
            var item = Award(name: dailyEventAwardName[i], detail: dailyEventAwardDetail[i])
            if item.awardName == "Morning" {
                item.granted.toggle()
                item.grantedTime = df.date(from: "2021-10-20")
            }
            if item.awardName == "Owl"{
                item.granted.toggle()
                item.grantedTime = df.date(from: "2021-09-12")
            }
            dailyEventAward.append(item)
            
        }
        for i in 0..<landmarkAwardName.count{
            var item = Award(name: landmarkAwardName[i], detail: landmarkAwardDetail[i])
            if item.awardName == "Hangzhou" {
                item.granted.toggle()
                item.grantedTime = df.date(from: "2021-07-22")
            }
            if item.awardName == "Shanghai"{
                item.granted.toggle()
                item.grantedTime = df.date(from: "2021-08-02")
            }
            landmarkAward.append(item)
        }
    }
    
    func update(award: Award){
        if let user = LCApplication.default.currentUser{
            do {
                let awardTable = LCObject(className: "Award")
                try awardTable.set("awardName", value: award.awardName)
                try awardTable.set("belongsTo", value: user)
                try awardTable.set("grantedTime", value: Date())
                
                _ = awardTable.save{ result in
                    switch result{
                    case .success:
                        break
                    case .failure(error: let error):
                        print(error)
                    }
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }

}


