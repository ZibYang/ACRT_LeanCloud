//
//  WhatMeansCreateView.swift
//  ACRT
//
//  Created by 章子飏 on 2021/11/2.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct WhatMeansCreateView: View {
    @Environment(\.dismiss) var dismissSheet
    @State private var index = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $index){
                createView
                    .tag(0)
                exploreView
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
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
    var exploreView: some View{
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
                    .gradientForeground(colors: [.orange, .green, Color(red: 96/255.0, green: 145/255.0, blue: 229/255.0), Color(red: 48/255.0, green: 83/255.0, blue: 229/255.0)])
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        
        var createView: some View{
            VStack{
                Text("Create")
                    .font(.title)
                    .bold()
                    .gradientForeground(colors: [.indigo, .green])
                    .padding()
                Image("create")
                    .resizable()
                    .aspectRatio(1/1, contentMode: .fit)
                    .gradientForeground(colors: [.purple, .indigo, .green, .yellow,.orange,.red])
                Text(AttributedString(localized:
                    "This time, **no longer to be just a person who obtains information!** You can express your emotion by placing models, decorating the city and so on, and everything will be renewed because of you!"))
                    .gradientForeground(colors: [.blue, .green, .yellow, .orange])
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
}

struct WhatMeansCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WhatMeansCreateView()
    }
}
