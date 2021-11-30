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
    
    var body: some View {
        VStack(alignment: .leading){
            
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Button(action:{
                }, label:{
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                    .font(.body)
                    
                })
                Text("Leave your message here")
                    .font(.headline)
                    .padding(.leading, 14)
                HStack{
                    TextField(LocalizedStringKey("Your message"), text: $message)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                    Button(action:{
                        messageModel.uploadMessage(message: message, creator: userModel.userName)
                    }, label:{
                        Text("Submit")
                    })
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                }
            }
            
        }
        .padding()
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
            .padding()
            .environmentObject(MessageViewModel())
        
        MessageView()
            .padding()
            .environmentObject(MessageViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
