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
            .gradientForeground(colors: [.blue, .orange, .green, .pink, .blue])
        }
        
    }
}

struct WelcomePageTitleView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageTitleView()
    }
}
