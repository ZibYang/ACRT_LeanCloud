//
//  WelcomePage.swift
//  ACRT
//

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/1.

//  Copyright © 2021 Augmented City Reality Toolkit. All Right Reserved.

// reference: https://developer.apple.com/videos/play/wwdc2019/237/
// [FaceID reference]: https://www.hackingwithswift.com/books/ios-swiftui/using-touch-id-and-face-id-with-swiftui

import SwiftUI

struct WelcomePage: View {
    @State private var index = 0
    @Environment(\.dismiss) var dismissSheet
    
    var body: some View {
        VStack(alignment: .center){
            
            ZStack {
                WelcomePageTitleView()
                HStack {
                    Spacer()
                    Button("Understand") {
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: "LaunchedBefore")
                        dismissSheet()
                    }
                    .padding(.trailing)
                }
            }
            .padding(.vertical)
            
            TabView(selection: $index){
                // FIXME: Replace with contents page
                WelcomePageDetail(imageName: "Welcome_A",
                                  title: "Augmented",
                                  detail:"A represents the Augmented Reality which enhanced the version of the real physical world, achieved through our iPhone and iPad.",
                                  theColor: Color(red: 0.15, green: 0.39, blue: 0.94))
                    .tag(0)
                WelcomePageDetail(imageName: "Welcome_R",
                                  title: "Reality",
                                  detail:"R stands for the reality. When virtual and reality mixed up, all familiar objects and scenes will become a whole new experience.",
                                  theColor: Color(red: 0.16, green: 0.91, blue: 0.66))
                    .tag(1)
                WelcomePageDetail(imageName: "Welcome_C",
                                  title: "City",
                                  detail:"C represents the city. This app will bring augmented reality into your city, allowing people to discover different magic in familiar cities.",
                                  theColor: Color(red: 0.93, green: 0.54, blue: 0.15))
                    .tag(2)
                WelcomePageDetail(imageName: "Welcome_T",
                                  title: "Toolkit",
                                  detail:"T stands for the toolkit. Give people wonderful tools, and they'll do wonderful things.",
                                  theColor: Color(red: 1.00, green: 0.39, blue: 0.49))
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

#if DEBUG
struct WelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
    }
}
#endif
