//
//  MessageView.swift
//  ACRT
//
//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/11/25.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct MessageView: View {
    @State var message: String = ""
    @EnvironmentObject var messageModel : MessageViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var placementSetting : PlacementSetting
    
    var body: some View {
        VStack(spacing: 0){
            
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("Leave your message here")
                    .font(.headline)
                    .padding(.leading)
                    .gradientForeground(colors: [.blue,.purple])
                HStack{
                    TextField(LocalizedStringKey("Your message"), text: $message)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        
                    Button(action:{
                        let df = DateFormatter()
                        df.dateStyle = .short
                        df.timeStyle = .short
                        messageModel.uploadMessage(message: message, creator: "[\(df.string(from: Date()))] " + userModel.userName + ":\n")
                        placementSetting.selectedModel = ""
                    }, label:{
                        Text("Submit")
                    })
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .ignoresSafeArea(.keyboard)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15, corners: [.topLeft, .topRight])
            
        }
        .adaptsToKeyboard()
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
            .environmentObject(MessageViewModel())
            .environmentObject(UserViewModel())
            .environmentObject(PlacementSetting())
        MessageView()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(MessageViewModel())
            .environmentObject(UserViewModel())
            .environmentObject(PlacementSetting())
    }
}
