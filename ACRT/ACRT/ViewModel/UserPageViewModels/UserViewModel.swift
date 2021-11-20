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
    
    @Published var userImage: UIImage?
    
    @Published var signUpErrorMessage = ""
    
    @Published var signInErrorMessage = ""
    
    @Published var signUpProcessing = false
    
    @Published var signInProcessing = false
    
    @Published var processingMessage = "Registering, please wait..."
    
    @Published var signUpError = false
    
    @Published var signInError = false
    
    //MARK: For prepareView
    let indicatorImageName = "AccountRequire"
    let indicatorTitle = "Login with Account"
    let indicatorDescription = "Log in to get full functionality experiences."
    
    init(){
        updateUserInfo()
    }
    
    func tryToSignUp(photo: UIImage?, username: String, password: String, email: String, phone: String, age: String){
        signUpProcessing.toggle()
        processingMessage = "Registering, please wait..."
        signUpErrorMessage = ""
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
                                        self.signUpProcessing.toggle()
                                        // sign up success then sign in directly
                                        _ = LCUser.logIn(username: username, password: password) { result in
                                            switch result {
                                            case .success(object: let user):
                                                self.updateUserInfo()
                                                print(user)
                                            case .failure(error: let error):
                                                print("[zzy userViewModel debug] error to sign in \(error)")
                                                if let errorInfo = error.reason{
                                                    self.signUpErrorMessage += "\n"
                                                    self.signUpErrorMessage += errorInfo
                                                }
                                                self.signUpError = true
                                            }
                                        }
                                        break
                                    case .failure(error: let error):
                                        self.signUpProcessing.toggle()
                                        if let errorInfo = error.reason{
                                            self.signUpErrorMessage += "\n"
                                            self.signUpErrorMessage += errorInfo
                                        }
                                        self.signUpError = true
                                        print("[zzy userViewModel debug] error to sign up \(error)")
                                    }
                                }
                            } catch {
                                print("[userViewModel debug] Errorcode : \(error as NSError)")
                            }
                        }
                    case .failure(error: let error):
                        print("[zzy userViewModel debug] error to upload URL \(error)")
                        self.signUpProcessing.toggle()
                        // save failed
                        if let errorInfo = error.reason{
                            self.signUpErrorMessage += errorInfo
                        }
                        self.signUpError = true
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
                            self.tryToLogin(account: username, password: password)
                            break
                        case .failure(error: let error):
                            if let errorInfo = error.reason{
                                self.signUpErrorMessage += "\n"
                                self.signUpErrorMessage += errorInfo
                                
                            }
                            self.signUpError = true
                            print("[zzy userViewModel debug] error to sign up \(error)")
                        }
                    }
                } catch {
                    print("[userViewModel debug] Errorcode : \(error as NSError)")
                }
            }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download image Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download image  Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.userImage = UIImage(data: data)
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
            if let imageURL = user.get("imageURL")?.stringValue{
                if let url = URL(string: imageURL){
                    downloadImage(from: url)
                }
            }
            print("[zzy] userImage loading")
            capabilitySatisfied = "satisfied"
            isSignedIn = true
        }else{
            capabilitySatisfied = "optional"
            isSignedIn = false
        }
    }
    
    func tryToLogin(account: String, password: String){
        signInErrorMessage = ""
        signInProcessing.toggle()
        processingMessage = "Signing in, please wait..."
        _ = LCUser.logIn(username: account, password: password){result in
            switch result {
            case .success(object: _):
                self.signInProcessing.toggle()
                self.updateUserInfo()
            case .failure(error: let error):
                self.signInProcessing.toggle()
                if let errorInfo = error.reason{
                    self.signInErrorMessage += errorInfo
                }
                self.signInError.toggle()
                return
            }
        }
    }
    
    func tryToLogout(){
        LCUser.logOut()
        self.capabilitySatisfied = "optional"
        isSignedIn = false
        userImage = nil
    }

}
