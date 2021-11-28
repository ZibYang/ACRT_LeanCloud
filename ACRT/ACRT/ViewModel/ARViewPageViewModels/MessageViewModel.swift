//
//  MessageViewModel.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/11/25.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation
import LeanCloud

class MessageViewModel : ObservableObject {
    @Published var isMessaging : Bool = false
    
    func uploadMessage(message: String, creator: String) {
        do {
            // 构建对象
            let object = LCObject(className: "Message")

            // 为属性赋值
            try object.set("message", value: message)
            try object.set("creator", value: creator)

            // 将对象保存到云端
            _ = object.save { result in
                switch result {
                case .success:
                    print("[meg] upload success")
                case .failure(error: let error):
                    // 异常处理
                    print("[meg] \(error)")
                }
            }
        } catch {
            print("[meg] \(error)")
        }
        isMessaging = false
    }
        
}
