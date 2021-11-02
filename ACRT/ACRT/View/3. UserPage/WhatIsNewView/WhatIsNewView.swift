//
//  WhatIsNewView.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/1.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

import SwiftUI

struct WhatIsNewView: View {
    var update: Update
    
    @State var pressed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center){
                Image(update.imageName)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 80)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey(update.updateTitle))
                            .font(.body)
                            .padding(.bottom, 3)
                        Text(LocalizedStringKey(updateTimeDisplay()))
                            .foregroundColor(.secondary)
                            .font(.footnote)
                            .padding(.bottom, 3)
                    }
                    .padding(.trailing, 30)
                }
            } // HStack
            
            Text(LocalizedStringKey(update.details))
                .foregroundColor(.secondary)
                .font(.footnote)
        }
    }
    
    func updateTimeDisplay() -> String{
        if Calendar.current.isDateInToday(update.updateTime){
            return "Today"
        }else if Calendar.current.isDateInYesterday(update.updateTime){
            return "Yesterday"
        }else{
            return update.updateTime.formatted(.dateTime.day().month().year())
        }
        
    }
}
                                  
struct WhatIsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatIsNewView(update: Update(imageName: "update1",
                                     updateTitle: "City Badges",
                                     updateTime: "2021/10/28",
                                     details: "We have launched the first batch of 3 city badges, visit the city and bring them home."))
    }
}
