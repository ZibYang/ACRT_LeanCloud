//
//  MessageView.swift
//  ACRT
//
//  Created by 李海 on 2021/11/28.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct MessageView: View {
    @State var message: String = ""
    @EnvironmentObject var messageModel : MessageViewModel
    
    var body: some View {
        VStack{
            Text("Leave your message here !!")
            Spacer()
            HStack{
                Text("Message")
                    .font(.body)
                    .frame(width:80, alignment: .leading)
                TextField(LocalizedStringKey("your message"), text: $message)
            }
            Spacer()
            Button(action:{
                messageModel.uploadMessage(message: message, creator: "root")
            }, label:{
                Text("Submit")
            })
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
