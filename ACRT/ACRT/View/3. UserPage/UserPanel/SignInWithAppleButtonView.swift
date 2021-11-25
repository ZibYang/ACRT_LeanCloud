//
//  SignInWithAppleButton.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/11/1.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//
// [SignWithApple] reference: https://www.youtube.com/watch?v=O2FVDzoAB34
import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        SignInWithAppleButton(.signIn,
                              onRequest: userViewModel.configure,
                              onCompletion: userViewModel.handle)
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(height: 45)
            .padding()
    }
}


struct SignInWithAppleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButtonView()
            .environmentObject(UserViewModel())
            .preferredColorScheme(.dark)
        SignInWithAppleButtonView()
            .environmentObject(UserViewModel())
            .previewDevice("iPhone 13")
    }
}
