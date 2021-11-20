//
//  WhatMeansExporeView.swift
//  ACRT
//
//  Created by 章子飏 on 2021/11/2.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct WhatMeansExploreView: View {
    @Environment(\.dismiss) var dismissSheet
    
    var body: some View {
        ZStack {
            VStack{
                Text("Explore")
                    .font(.title)
                    .bold()
                    .gradientForeground(colors: [.orange, .green])
                    .padding()
                Image("explore")
                    .resizable()
                    .aspectRatio(1/1, contentMode: .fit)
                    .gradientForeground(colors: [.red, .orange, .yellow, .green,.blue,.purple])
                Text(AttributedString(localized:
                    "Anytime, anywhere, after you lift up your mobile phone to complete the positioning, **you can explore endless wonders in the designated area of the city.** It may be a different-dimensional food or a magical animal. Everything is waiting for you!"))
                    .gradientForeground(colors: [.green, Color(red: 96/255.0, green: 145/255.0, blue: 229/255.0), Color(red: 48/255.0, green: 83/255.0, blue: 229/255.0)])
                    .multilineTextAlignment(.center)
                    .padding()
                
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button("Understand") {
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: "LaunchedBefore")
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

struct WhatMeansExploreView_Previews: PreviewProvider {
    static var previews: some View {
        WhatMeansExploreView()
    }
}
