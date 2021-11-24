//
//  UserCapabilityView.swift
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
//

import SwiftUI

struct UserCapabilityView: View {
    let labelImage: String
    let labelText: String
    
    @Binding var buttonTapped: Bool
    
    var body: some View {
        HStack{
            Image(systemName: labelImage)
                .foregroundColor(labelImage == "checkmark.circle" ? .green : .yellow)
            Text(LocalizedStringKey(labelText))
                .foregroundColor(.primary)
                .lineLimit(1)
            Button(action:{
                let impactLight = UIImpactFeedbackGenerator(style: .light)
                impactLight.impactOccurred()
                buttonTapped.toggle()
            }, label:{
                Image(systemName: "questionmark.circle")
            })
        }
    }
}

struct UserCapabilityView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserCapabilityView(labelImage: "checkmark.circle",
                               labelText: "Logged-in user can:",
                               buttonTapped: .constant(false))
            UserCapabilityView(labelImage: "exclamationmark.circle",
                               labelText: "Tourist can:",
                               buttonTapped: .constant(true))
            UserCapabilityView(labelImage: "exclamationmark.circle",
                               labelText: "Tourist can:",
                               buttonTapped: .constant(true))
        }
    }
}
