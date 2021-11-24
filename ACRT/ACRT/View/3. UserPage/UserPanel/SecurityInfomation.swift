//
//  SecurityInfomation.swift
//  ACRT
//
//  Created by Lab509 on 2021/11/21.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct SecurityInfomation: View {
    @Environment(\.dismiss) var dismissSheet
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 50) {
                Text("Privacy")
                    .font(.title)
                    .bold()
                    .gradientForeground(colors: [.blue, .pink])
                Text("Privacy is a fundamental human right. It’s also one of Apple's core values and so are we. Your devices are important to so many parts of your life. What you share from those experiences, and who you share it with, should be up to you. In our app you have full control over your information. It’s not always easy. But that’s the kind of innovation we believe in.")
                HStack{
                    Image(systemName: "mappin.slash.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .padding()
                    VStack(alignment: .leading){
                        Text("Your location history is history")
                            .font(.title3)
                            .bold()
                            .gradientForeground(colors: [.blue, .purple])
                        Text("In our app, we doesn’t associate your data with your account, and we doesn’t keep a history of where you’ve been.")
                    }
                }
                
                HStack{
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .aspectRatio(1.15, contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .symbolRenderingMode(.multicolor)
                        .foregroundColor(.indigo)
                        .padding()
                    VStack(alignment: .leading){
                        Text("Your picture stays a mystery")
                            .font(.title3)
                            .bold()
                            .gradientForeground(colors: [.purple, .orange])
                        Text("Your photo will directly save into your album with protect by Apple, and we won't save it in our severs.")
                    }
                }
            }
            .padding()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Understand") {
                        impactLight.impactOccurred()
                        dismissSheet()
                    }
                    .padding(.trailing)
                }
                Spacer()
            }
        }
        .padding(.vertical)
    }
}

struct SecurityInfomation_Previews: PreviewProvider {
    static var previews: some View {
        SecurityInfomation()
    }
}
