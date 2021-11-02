//
//  UserCapabilityView.swift
//  ACRT
//
//  Created by 章子飏 on 2021/11/1.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct UserCapabilityView: View {
    let labelImage: String
    let labelText: String
    let buttonText: String
    
    @Binding var capabilityLevel: String
    @Binding var buttonTapped: Bool
    
    var body: some View {
        Button(action:{
            buttonTapped.toggle()
        }, label:{
            HStack{
                Image(systemName: labelImage)
                    .foregroundColor(labelImage == "checkmark.circle" && capabilityLevel == "satisfied" ? .green : labelImage == "checkmark.circle" ? .gray : labelImage == "exclamationmark.circle" && capabilityLevel == "optional" ? .yellow : .gray)
                Text(LocalizedStringKey(labelText))
                    .foregroundColor(labelImage == "checkmark.circle" && capabilityLevel == "satisfied" ? .primary : labelImage == "checkmark.circle" ? .secondary : labelImage == "exclamationmark.circle" && capabilityLevel == "optional" ? .primary : .secondary)
                    .lineLimit(1)
                Text(LocalizedStringKey(buttonText))
                    .lineLimit(1)
            }
        })
        .disabled(labelImage == "checkmark.circle" && capabilityLevel != "satisfied")
    }
}

struct UserCapabilityView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserCapabilityView(labelImage: "checkmark.circle",
                               labelText: "Logged-in user can:",
                               buttonText: "exproe and create",
                               capabilityLevel: .constant("satisfied"),
                               buttonTapped: .constant(false))
            UserCapabilityView(labelImage: "exclamationmark.circle",
                               labelText: "Tourist can:",
                               buttonText: "exproe",
                               capabilityLevel: .constant("optional"),
                               buttonTapped: .constant(true))
        }
    }
}
