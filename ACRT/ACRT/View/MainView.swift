//
//  ContentView.swift
//  ACRT_new

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/1.

//  Copyright © 2021 Augmented City Reality Toolkit. All Right Reserved.
// [UserDefault] reference 1: https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults
//               reference 2: https://cloud.tencent.com/developer/article/1018231
// [ViewWithSheet] reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-present-a-new-view-using-sheets
// [localization] reference: https://developer.apple.com/documentation/bundleresources/information_property_list/nsphotolibraryusagedescription
// [LaunchScreen] reference: https://www.youtube.com/watch?v=3CasiUiJPVo
import SwiftUI

struct MainView: View {
    @State private var presentWelcomeSheet: Bool
    
    // Check whether first launch or not
    init(){
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "LaunchedBefore") == true{
            presentWelcomeSheet = false
        }else{
            presentWelcomeSheet = true
        }
    }
    
    var body: some View {
        PrepareView(introduceAgain: $presentWelcomeSheet)
            .sheet(isPresented: $presentWelcomeSheet){
                WelcomePage()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
        MainView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}
