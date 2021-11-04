//
//  UserViewModel.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/5.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

import SwiftUI
import LeanCloud

class UserViewModel: ObservableObject{
    @Published var capabilitySatisfied = "optional"
    
    @Published var isSignedIn = false
    
    //MARK: For prepareView
    let indicatorImageName = "AccountRequire"
    let indicatorTitle = "Login with Account"
    let indicatorDescription = "Log in to get full functionality experiences."
    
    init(){
        if let user = LCApplication.default.currentUser{
            // TODO: other infomation
            capabilitySatisfied = "satisfied"
            isSignedIn = true
        }else{
            capabilitySatisfied = "optional"
            isSignedIn = false
        }
    }
    
    func tryToSignUp(photoURL: URL?, username: String, password: String, email: String, phone: String, age: String){
        do {
            let user = LCUser()  // create a new User
            try user.set("username", value: username) // equal user.username = LCString("Tom")
            try user.set("password", value: password)
            
            // Optional
            try user.set("email", value: email)
            try user.set("mobilePhoneNumber", value: "+86"+phone)
            try user.set("password", value: password)
            // User Image
            if let url = photoURL{
                let file = LCFile(payload: .fileURL(fileURL: url))
                _ = file.save() { (result) in
                    switch result {
                    case .success:
                        // save success
                        if let value = file.url?.value {
                            print("[zzy]Image saved, URL is: \(value)")
                            do{
                                try user.set("imageURL", value: file)
                            }catch{
                                print("[zzy] error to save URL to user: \(error)")
                            }
                        }
                    case .failure(error: let error):
                        // save failed
                        print("[zzy] error to upload URL \(error)")
                    }
                }
            }
            
            _ = user.signUp { (result) in
                switch result {
                case .success:
                    // sign up success then sign in directly
                    _ = LCUser.logIn(username: username, password: password) { result in
                        switch result {
                        case .success(object: let user):
                            self.isSignedIn = true
                            self.capabilitySatisfied = "satisfied"
                            print(user)
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                    break
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(" errorcode : \(error as NSError)")
        }
    }
    
    func tryToLogin(account: String, password: String) -> Int{
        var logInStatus = 0
        _ = LCUser.logIn(username: account, password: password){result in
            switch result {
            case .success(object: _):
                self.isSignedIn.toggle()
                logInStatus = 1
            case .failure(error: _):
                logInStatus = 0
            }
        }
        return logInStatus
    }
    
    func tryToLogout(){
        LCUser.logOut()
        self.capabilitySatisfied = "optional"
        isSignedIn = false
    }
    
    func sendVarifyCode(phoneNumber: String)-> Int{
        var status = 0
        _ = LCUser.requestVerificationCode(mobilePhoneNumber: "+86"+phoneNumber) { result in
            switch result {
            case .success:
                status = 1
                break
            case .failure(error: let error):
                print("[zzy]varify code error: \(error)")
            }
        }
        return status
    }
}
