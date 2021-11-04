//
//  IndicatorView.swift
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

struct IndicatorView: View {
    @Environment(\.colorScheme) var colorScheme
    let indicatorImageName: String
    let indicatorTitle: String
    let indicatorDescriptions: String
    
    @Binding var satisfied: String
    
    var body: some View {
        HStack {
            Image(colorScheme == .dark ? indicatorImageName+"_dark" : indicatorImageName+"_bright")
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 80, height: 80)
            VStack(alignment: .leading) {
                HStack{
                    Text(LocalizedStringKey(indicatorTitle))
                        .font(.headline)
                        .padding(.bottom, 2)
                        .lineLimit(1)
                    Image(systemName: satisfied == "satisfied" ? "checkmark.circle" : satisfied == "optional" ? "exclamationmark.circle" : "multiply.circle")
                        .foregroundColor(satisfied == "satisfied" ? .green : satisfied == "optional" ? .yellow : .red)
                }
                Text(LocalizedStringKey(indicatorDescriptions))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(alignment: .leading)
                    .lineLimit(1)
            }
            .padding(.bottom, 5)
        }
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView(indicatorImageName: "AccountRequire",
                      indicatorTitle: "Log in with Account",
                      indicatorDescriptions: "Log in to get full functionality experiences.",
                      satisfied: .constant("optional"))
    }
}
