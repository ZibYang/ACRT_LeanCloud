//
//  AwardView.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/8.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

import SwiftUI

struct AwardView: View {
    @EnvironmentObject var awardModel: AwardModel
    
    let columns = [
            GridItem(.adaptive(minimum: 120))
        ]
    
    
    var body: some View {
        LazyVStack(alignment: .leading){            
            Text("Special Event")
                .padding()
                .font(.body)
            SpecialEventAwardView
            Divider()
                .padding(.horizontal)
            Text("Daily Event")
                .padding()
                .font(.body)
            DailyEventAwardView
            Divider()
                .padding(.horizontal)
            Text("LandMark")
                .padding()
                .font(.body)
            LandmarkAwardView
        }
    }
    
   
    
    var SpecialEventAwardView: some View{
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<awardModel.specialEventAward.count, id: \.self){ i in
                VStack{
                    SingleRoundAwardView(award: $awardModel.specialEventAward[i])
                    Button(action: {
                        awardModel.specialEventAward[i].grantedTime = Date()
                        awardModel.specialEventAward[i].granted.toggle()
                    }, label: {
                        Text("test")
                    })
                }
            }
        }
    }
    
    var DailyEventAwardView: some View{
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<awardModel.dailyEventAward.count, id: \.self){ i in
                VStack{
                    SingleRoundAwardView(award: $awardModel.dailyEventAward[i])
                    Button(action: {
                        awardModel.dailyEventAward[i].grantedTime = Date()
                        awardModel.dailyEventAward[i].granted.toggle()
                    }, label: {
                        Text("test")
                    })
                }
            }
        }
    }
    
    var LandmarkAwardView: some View{
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<awardModel.landmarkAward.count, id: \.self){ i in
                VStack{
                    SingleRoundAwardView(award: $awardModel.landmarkAward[i])
                    Button(action: {
                        awardModel.landmarkAward[i].grantedTime = Date()
                        awardModel.landmarkAward[i].granted.toggle()
                    }, label: {
                        Text("test")
                    })
                }
            }
        }
    }
        
        
}

struct AwardView_Previews: PreviewProvider {
    static var previews: some View {
        
        Text("Hello")
            .sheet(isPresented: .constant(true), content: {
                NavigationView {
                    ScrollView{
                        AwardView()
                            .environmentObject(AwardModel())
                    }
                }
            })
    }
}
