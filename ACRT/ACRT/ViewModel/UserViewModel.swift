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
    
    @Published var userName = ""
    
    @Published var userAge = ""
    
    @Published var userImage = ""
    
    //MARK: For prepareView
    let indicatorImageName = "AccountRequire"
    let indicatorTitle = "Login with Account"
    let indicatorDescription = "Log in to get full functionality experiences."
    
    init(){
        updateUserInfo()
    }
    
    func tryToSignUp(photoURL: URL?, username: String, password: String, email: String, phone: String, age: String){
        do {
            let user = LCUser()  // create a new User
            try user.set("username", value: username) // equal user.username = LCString("Tom")
            try user.set("password", value: password)
            try user.set("age", value: age)
            
            // Optional
            try user.set("email", value: email)
            try user.set("mobilePhoneNumber", value: phone)
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
                            self.updateUserInfo()
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
    
    func updateUserInfo(){
        if let user = LCApplication.default.currentUser{
            // TODO: other infomation
            if let name = user.get("username")?.stringValue{
               userName = name
            }
            if let age = user.get("age")?.stringValue{
                userAge = age
            }else{
                userAge = "Unknown"
            }
            if let image = user.get("imageURL")?.stringValue{
                userImage = image
            }
            print("[zzy] userImage: \(userImage)")
            capabilitySatisfied = "satisfied"
            isSignedIn = true
        }else{
            capabilitySatisfied = "optional"
            isSignedIn = false
        }
    }
    
    func tryToLogin(account: String, password: String) -> Int{
        var logInStatus = 0
        _ = LCUser.logIn(username: account, password: password){result in
            switch result {
            case .success(object: _):
                self.updateUserInfo()
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

}
