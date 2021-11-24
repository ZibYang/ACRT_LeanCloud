//
//  SignInWithEmailAndPasswordView.swift
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

// [localize SecureField in iOS 15] reference: https://stackoverflow.com/questions/69293197/textfield-swiftui-xcode-13
// [focusState] reference: https://developer.apple.com/documentation/swiftui/focusstate
// [List Is already Scrollable] reference: https://developer.apple.com/forums/thread/126898
// [hide keyBoard] reference: https://designcode.io/swiftui-handbook-hide-keyboard

import SwiftUI

struct SignInWithEmailAndPasswordView: View {
    @EnvironmentObject var userModel: UserViewModel
    
    @Environment(\.dismiss) var dismissLoginSheet
    @FocusState private var focusedField: Field? // Email Password Field
    @State var inputAccount = ""
    @State var inputPassword = ""
    
    @State var emptyEmail = false
    @State var emptyPassword = false
    @State var incorrectInput = false
    
    @State var signUpNow = false
    @State var fogetPasswordPressed = false
    
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack {
            NavigationView {
                List{
                    Section {
                        emailSheet
                            
                        passwordSheet
                            
                    }// Info input Section
                    
                    Section(content: {
                        signInButton
                    }, footer: {
                        fogetPasswordSheet
                    }) // Button Section
                    
                    Section(header: Text("What's new"), content: {
                        ForEach(whatIsNew.updates, id:\.self){updateMessage in
                            WhatIsNewView(update: updateMessage)
                        }
                    }) // What's new Section
                    
                } // List
                .onSubmit {
                    switch focusedField{
                    case .account:
                        focusedField = .password
                    default:
                        checkAndLogIn()
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        traillingTollBarItem
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        leadingTollBarItem
                    }
                }
                .navigationTitle(Text("Log in"))
                .navigationBarTitleDisplayMode(.inline)
            } // navigation
            
            if userModel.signInProcessing || userModel.signUpProcessing{
                Color.black
                    .opacity(0.8)
                    .ignoresSafeArea()
                ProgressView(LocalizedStringKey(userModel.processingMessage))
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
            }
        }
        .environmentObject(userModel)
        .alert(isPresented: $userModel.signUpError){
            Alert(title: Text("Apologize"),
                  message:Text(LocalizedStringKey(userModel.signUpErrorMessage)),
                  dismissButton: .default(Text("OK")))
        }
    }
        
    var emailSheet: some View{
        HStack{
            Text("Account")
                .font(.body)
                .frame(width:80, alignment: .leading)
            TextField(LocalizedStringKey("User account name"), text: $inputAccount)
                .focused($focusedField, equals: .account)
                .textContentType(.emailAddress)
                .submitLabel(.next)
        }
        .alert(isPresented: $emptyEmail){
            Alert(title: Text("Apologize"),
                  message: Text("Empty email is not acceptable"),
                  dismissButton: .destructive(Text("Got it")))
        }
    }
    
    var passwordSheet: some View{
        HStack{
            Text("Password")
                .font(.body)
                .frame(width:80, alignment: .leading)
            SecureField("Required", text: $inputPassword, prompt: Text("Required"))
                .keyboardType(.namePhonePad)
                .focused($focusedField, equals: .password)
                .submitLabel(.join)
        }
        .alert(isPresented: $emptyPassword){
            Alert(title: Text("Apologize"),
                  message: Text("Empty password is not acceptable"),
                  dismissButton: .default(Text("Got it")))
        }
    }
    
    var fogetPasswordSheet: some View{
        HStack{
            Spacer()
            Button(action:{
                impactLight.impactOccurred()
                fogetPasswordPressed.toggle()
            }, label:{
                Text("Forget account or password?")
            })
            Spacer()
        }
        .alert(isPresented: $fogetPasswordPressed){
            Alert(title: Text("Apologize"),
                  message: Text("Can not reset password now \n Please contact with admin."),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    var signInButton: some View{
        Button(action: {
            impactLight.impactOccurred()
            checkAndLogIn()
        }, label: {
            Text("Log in")
        })
            .alert(isPresented: $emptyEmail){
                Alert(title: Text("Apologize"),
                      message: Text("Empty email is not acceptable."),
                      dismissButton: .destructive(Text("Got it")))
            }
            .alert(isPresented: $emptyPassword){
                Alert(title: Text("Apologize"),
                      message: Text("Empty password is not acceptable."),
                      dismissButton: .default(Text("Got it")))
            }
            .alert(isPresented: $userModel.signInError){
                Alert(title: Text("Error"),
                      message: Text(LocalizedStringKey(userModel.signInErrorMessage)),
                      dismissButton: .default(Text("Try it again")))
            }
            
    }
    
    var leadingTollBarItem: some View{
        Button(action: {
            impactLight.impactOccurred()
            signUpNow.toggle()
        }, label: {
            Text("Sign up")
        })
        .sheet(isPresented: $signUpNow, content: {
            SignUpView()
        })
    }
    
    var traillingTollBarItem: some View{
        Button(action:{
            impactLight.impactOccurred()
            dismissLoginSheet()
        }){
            Text("Not now")
                .foregroundColor(.secondary)
        }
    }
    
    func checkAndLogIn(){
        hideKeyboard()
        if inputAccount.isEmpty{
            emptyEmail.toggle()
            focusedField = .account
            return
        }else if inputPassword.isEmpty{
            emptyPassword.toggle()
            focusedField = .password
            return
        }else{
            userModel.tryToLogin(account: inputAccount, password: inputPassword)
        }
    }
}

extension SignInWithEmailAndPasswordView {
    private enum Field: Int, CaseIterable {
        case account, password
    }
}


struct SignInWithEmailAndPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailAndPasswordView()
            .environmentObject(UserViewModel())
    }
}
