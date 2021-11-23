//
//  UserCircleView.swift
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
//

import SwiftUI

struct UserCircleView: View {
    @EnvironmentObject var userModel: UserViewModel
    
    var body: some View {
        Button(action: {
            let impactLight = UIImpactFeedbackGenerator(style: .light)
            impactLight.impactOccurred()
            userModel.showUserPanel.toggle()
        }, label:{
            Image(uiImage: userModel.userImage == nil ? UIImage(systemName: "person.crop.circle")! : userModel.userImage!)
                .renderingMode(userModel.userImage == nil ? .template : .original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: userModel.userImage == nil ? 35: 45, height: userModel.userImage == nil ? 35 :45)
                .clipShape(Circle())
                .padding(userModel.userImage == nil ? 7 : 0)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        })
            .sheet(isPresented: $userModel.showUserPanel){
                if userModel.isSignedIn{
                    UserLoggedinView()
                }else{
                    SignInWithEmailAndPasswordView()
                }
            }
            .environmentObject(userModel)
    }
}

struct UserCircleView_Previews: PreviewProvider {
    static var previews: some View {
        UserCircleView()
            .environmentObject(UserViewModel())
    }
}
