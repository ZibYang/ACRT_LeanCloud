//
//  WelcomePageTitleView.swift
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

struct WelcomePageTitleView: View {
    var body: some View {
        HStack {
            HStack(spacing: 0){
                Text("Introduce ")
                    .bold()
                Text("ACRT")
                    .bold()
                    
            }
            .gradientForeground(colors: [Color(red: 0.15, green: 0.39, blue: 0.94),
                                         Color(red: 0.93, green: 0.54, blue: 0.15),
                                         Color(red: 0.16, green: 0.91, blue: 0.66),
                                         Color(red: 1.00, green: 0.39, blue: 0.49)])
        }
        
    }
}

struct WelcomePageTitleView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageTitleView()
    }
}
