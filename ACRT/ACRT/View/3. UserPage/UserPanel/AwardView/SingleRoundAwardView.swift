//
//  SingleRoundAwardView.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/8.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct SingleRoundAwardView: View {
    @Binding var award: Award
    
    var body: some View {
        VStack() {
            Image(award.state() ? award.awardName + "_granted" : award.awardName + "_ungranted")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 5, x: 0, y: 5)
            VStack{
                Text(LocalizedStringKey(award.awardName))
                    .font(.body)
                Text(award.state() ? award.timeDisplay : "")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .offset(y: -10)
        }
    }
}

struct SingleRoundAwardView_Previews: PreviewProvider {
    static var previews: some View {
        SingleRoundAwardView(award: .constant(Award(name: "Hangzhou", detail: "Welcom to HangZhou")))
    }
}
