//
//  PermisionDeniedView.swift
//  ACRT
//

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team

//  Created by Lab509 on 2021/7/3.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

import SwiftUI

struct PermisionDeniedView: View {
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed.toggle()
        }, label: {
            HStack {
                Text("Location Services is off")
                    .font(.body)
                Image(systemName: "chevron.right")
            } // HStack
            .foregroundColor(.blue)
        }) // Button
        .alert("ACRT works best with Location Services turned on", isPresented: $isPressed){
            Button(role: .none){
                isPressed = false
            }label:{
                Text("Keep it that way")
            }
            Button(role: .cancel){
                isPressed = false
                UIApplication.shared.open(URL(string:
                                                UIApplication.openSettingsURLString)!)
            }label:{
                Text("Turn On in Settings")
            }
        } message: {
            Text("You'll get a brunch of featues improved when you turn on the Location Services for ACRT")
        }
    } // body
}

struct PermisionDeniedView_Previews: PreviewProvider {
    static var previews: some View {
        PermisionDeniedView()
    }
}
