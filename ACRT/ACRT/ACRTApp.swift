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

// reference: https://gist.github.com/Harry-Harrison/e4217a6d8c4cfbee1aa5128c4491a149
struct HapticTest: View {
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack(alignment: .center, spacing: 30.0) {
            Button(action: {
                self.generator.notificationOccurred(.success)
            }) {
                Text("Notification - Success")
            }
            
            Button(action: {
                self.generator.notificationOccurred(.error)
            }) {
                Text("Notification - Error")
            }
            
            Button(action: {
                self.generator.notificationOccurred(.warning)
            }) {
                Text("Notification - Warning")
            }
            
            Button(action: {
                let impactLight = UIImpactFeedbackGenerator(style: .light)
                impactLight.impactOccurred()
            }) {
                Text("Impact - Light")
            }
            
            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }) {
                Text("Impact - Medium")
            }
            
            Button(action: {
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
            }) {
                Text("Impact - Heavy")
            }
            
            Button(action: {
                let selectionFeedback = UISelectionFeedbackGenerator()
                selectionFeedback.selectionChanged()
            }) {
                Text("Selection Feedback - Changed")
            }
        }
        .padding(.all, 30.0)
    }
}

struct HapticTest_Previews: PreviewProvider {
    static var previews: some View {
        HapticTest()
    }
}
