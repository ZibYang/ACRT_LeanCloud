//
//  SignUpViewModel.swift
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

import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject{
    @Published var focusedField: Field?
    
    @Published var contentOffset = CGFloat(0)
    
    //MARK: Error sign
    
    @Published var userNameError = false // User Name Error
    @Published var incorrectAge = false // User Age Error
    @Published var phoneNumberError = false // User Phone Error
    @Published var emailError = false // User Email Error
    @Published var passwordError = false // User Password Error
    
    @Published var showErrorMessage = false // User Info Error
    
    //MARK: Error Message
    let errorTitle = "Apologize"
    let userNameErrorMessage = "Please follow the naming rules\n 1. Start with letter \n 2. Length between 4 and 20"
    let ageErrorMessage = "Age can not above 99"
    let phoneErrorMessage = "Please input right phone number"
    let emailErrorMessage = "Please input right email"
    let passwordErrorMessage = "Please follow the password setting rules\n 1. Start with a capital letter \n 2. Length must exceeds 8 digits"
    //MARK: Basic Infomation
    @Published var image: Image? // User Image
    @Published var inputImage: UIImage?
    @Published var chosesImgButtonPressed = false
    @Published var showCamera = false
    @Published var showImagePicker = false
    @Published var photoURL = URL(string: "")
    
    @Published var userName = "" // User Name
    @Published var age = "" // User Age

    //MARK: Secured Infomation
    @Published var phoneNumber = "" // User Phone
    @Published var email = "" // User Email
    @Published var password = "" // User Password
    
    // MARK: Finishing
    @Published var showProgressView = false
    
    // Focus Field FIXME: Not working
    enum Field: Int, CaseIterable {
        case userName, age, phone, varifyCode, mail, password
    }
    
    func validatePhone(){
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phoneTest.evaluate(with: self.phoneNumber){
            phoneNumberError.toggle()
            phoneNumber = ""
            focusedField = .phone
        }else{
            focusedField = .mail
        }
    }
    
    func validateEmail(){
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailTest.evaluate(with: self.email){
            emailError.toggle()
            email = ""
            focusedField = .mail
        }
        else{
            focusedField = .password
        }
    }
    
    func validateUserName(){
        let userNameRegex = "^[A-Za-z0-9]{4,20}+$"
        let userNamePredicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
        if !userNamePredicate.evaluate(with: self.userName){
            userNameError.toggle()
            userName = ""
            focusedField = .userName
        }else{
            focusedField = .age
        }
    }
    
    func validateAge(){
        if age.count > 2{
            age = ""
            incorrectAge.toggle()
            focusedField = .age
        }else{
            focusedField = .phone
        }
    }
    func validatePassword(){
        let passWordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        if !passWordPredicate.evaluate(with: self.password){
            passwordError.toggle()
            password = ""
            focusedField = .password
        }else{
            focusedField = nil
        }
    }
    
    func AllInfomationWithNoError()->Bool{
        validateUserName()
        validateAge()
        
        validatePhone()
        validateEmail()
        validatePassword()
        
        if !userNameError && !incorrectAge && !phoneNumberError && !emailError && !passwordError{
            return true
        }else{
            return false
        }
    }
    
}
