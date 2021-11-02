//
//  UserCircleView.swift
//  ACRT
//
//  Created by 章子飏 on 2021/11/2.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct UserCircleView: View {
    @EnvironmentObject var userModel: UserViewModel
    
    @State var showUserPanel = false
    
    var body: some View {
        Button(action: {
            showUserPanel.toggle()
        }, label:{
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .padding(6)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        })
            .sheet(isPresented: $showUserPanel){
                if userModel.isSignedIn{
                    UserLoggedinView()
//                        .environmentObject(userModel)
//                        .environmentObject(awardModel)
                }else{
                    SignInWithEmailAndPasswordView()
                }
            }
    }
}

struct UserCircleView_Previews: PreviewProvider {
    static var previews: some View {
        UserCircleView()
    }
}
