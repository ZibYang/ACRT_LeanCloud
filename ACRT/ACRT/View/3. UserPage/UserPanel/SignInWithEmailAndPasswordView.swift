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

import SwiftUI

struct SignInWithEmailAndPasswordView: View {
    @Environment(\.dismiss) var dismissLoginSheet
    @FocusState private var focusedField: Field? // Email Password Field
    @State var inputEmail = ""
    @State var inputPassword = ""
    
    @State var emptyEmail = false
    @State var emptyPassword = false
    
    @State var signUpNow = false
    
    var body: some View {
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
                    leadingTollBarItem
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    traillingTollBarItem
                }
            }
            .navigationTitle(Text("Log in"))
            .navigationBarTitleDisplayMode(.inline)
        } // navigation
        
    }
        
    var emailSheet: some View{
        HStack{
            Text("Account")
                .font(.body)
                .frame(width:80, alignment: .leading)
            TextField(LocalizedStringKey("Email Account"), text: $inputEmail)
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
            }, label:{
                Text("Forget account or password?")
            })
            Spacer()
        }
    }
    
    var signInButton: some View{
        Button(action: {
            checkAndLogIn()
        }, label: {
            Text("Log in")
        })
    }
    
    var leadingTollBarItem: some View{
        Button(action: {
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
            dismissLoginSheet()
        }){
            Text("Not now")
                .foregroundColor(.secondary)
        }
    }
    
    func checkAndLogIn(){
        if inputEmail.isEmpty{
            print("empty email")
            emptyEmail = true
            focusedField = .account
        }else if inputPassword.isEmpty{
            print("empty password")
            emptyPassword = true
            focusedField = .password
        }else{
            print("Logging in with botton")
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
    }
}
