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
    
    @Published var userImageuserImage = ""
    
    @Published var message = ""
    
    @Published var signUpError = false
    
    //MARK: For prepareView
    let indicatorImageName = "AccountRequire"
    let indicatorTitle = "Login with Account"
    let indicatorDescription = "Log in to get full functionality experiences."
    
    init(){
        updateUserInfo()
    }
    
    func tryToSignUp(photo: UIImage?, username: String, password: String, email: String, phone: String, age: String){
        message = ""
            // User Image
            if let image = photo{
                let file = LCFile(payload: .data(data: image.pngData()!))
                _ = file.save() { (result) in
                    switch result {
                    case .success:
                        // save success
                        if let value = file.url?.value {
                            print("[zzy userViewModel debug] Image saved, URL is: \(value)")
                            do {
                                let user = LCUser()  // create a new User
                                try user.set("username", value: username) // equal user.username = LCString("Tom")
                                try user.set("password", value: password)
                                try user.set("age", value: age)
                                
                                // Optional
                                try user.set("email", value: email)
                                try user.set("mobilePhoneNumber", value: phone)
                                try user.set("password", value: password)
                                try user.set("imageURL", value: file.url!)
                                
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
                                                print("[zzy userViewModel debug] error to sign in \(error)")
                                                if let errorInfo = error.reason{
                                                    self.message += "\n"
                                                    self.message += errorInfo
                                                    self.signUpError = true
                                                    return
                                                }
                                            }
                                        }
                                        break
                                    case .failure(error: let error):
                                        if let errorInfo = error.reason{
                                            self.message += "\n"
                                            self.message += errorInfo
                                            self.signUpError = true
                                            return
                                        }
                                        print("[zzy userViewModel debug] error to sign up \(error)")
                                    }
                                }
                            } catch {
                                print("[userViewModel debug] Errorcode : \(error as NSError)")
                            }
                        }
                    case .failure(error: let error):
                        print("[zzy userViewModel debug] error to upload URL \(error)")
                        // save failed
                        if let errorInfo = error.reason{
                            self.message += errorInfo
                            self.signUpError = true
                        }
                    }
                }
            } else {
                do {
                    let user = LCUser()  // create a new User
                    try user.set("username", value: username) // equal user.username = LCString("Tom")
                    try user.set("password", value: password)
                    try user.set("age", value: age)
                    
                    // Optional
                    try user.set("email", value: email)
                    try user.set("mobilePhoneNumber", value: phone)
                    try user.set("password", value: password)
                    
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
                                    print("[zzy userViewModel debug] error to sign in \(error)")
                                    if let errorInfo = error.reason{
                                        self.message += "\n"
                                        self.message += errorInfo
                                        self.signUpError = true
                                        return
                                    }
                                }
                            }
                            break
                        case .failure(error: let error):
                            if let errorInfo = error.reason{
                                self.message += "\n"
                                self.message += errorInfo
                                self.signUpError = true
                                return
                            }
                            print("[zzy userViewModel debug] error to sign up \(error)")
                        }
                    }
                } catch {
                    print("[userViewModel debug] Errorcode : \(error as NSError)")
                }
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
