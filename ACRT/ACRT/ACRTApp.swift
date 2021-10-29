//
//  ACRTApp.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/1.

//  Copyright © 2021 Augmented City Reality Toolkit. All Right Reserved.

// [Coredata] reference: https://www.cnblogs.com/yajunLi/p/6600700.html
// [leanCloud] reference: https://leancloud.cn/docs/sdk_setup-swift.html#hash-1726498857

import SwiftUI
import LeanCloud

@main
struct ACRTApp: App {
    init(){
        // MARK: leanCloud
        do {
            try LCApplication.default.set(
                id:  "Mq6Gpwowd0teA0TKscJ5aXS4-MdYXbMMI",
                key: "QBSWfSdWyRdvAEE6KjTqXTpb")
            LCApplication.logLevel = .all
        } catch {
            print(error)
        }
    }
    
    // MARK: Scene
    var body: some Scene {
        WindowGroup {
            // MARK: View
            MainView()
        }
    }
}
