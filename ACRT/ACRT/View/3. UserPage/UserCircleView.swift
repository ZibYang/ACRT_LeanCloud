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
    
    @State var showUserPanel = false
    
    var body: some View {
        Button(action: {
            showUserPanel.toggle()
        }, label:{
            Image(uiImage: userModel.userImage == nil ? UIImage(systemName: "person.crop.circle")! : userModel.userImage!)
                .renderingMode(userModel.userImage == nil ? .template : .original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .padding(7)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        })
            .sheet(isPresented: $showUserPanel){
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
