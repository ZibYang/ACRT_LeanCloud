//
//  SignUpView.swift
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
// [VarifyPhoneNumber] reference: https://www.jianshu.com/p/3d36474a01d7
// [ButtonDisable] reference: https://www.hackingwithswift.com/quick-start/swiftui/enabling-and-disabling-elements-in-forms
// [ActionSheet] reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-an-action-sheet
// [confirmation] reference 1: https://developer.apple.com/documentation/swiftui/view/confirmationdialog(_:ispresented:titlevisibility:actions:)-46zbb
//                reference 2: https://developer.apple.com/documentation/swiftui/visibility


import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismissSheet
    
    @EnvironmentObject var userModel: UserViewModel
    
    @FocusState private var focusedField: Field?
    @State private var contentOffset = CGFloat(0)
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    @State private var chosesImgButtonPressed = false
    @State private var showCamera = false
    @State private var showImagePicker = false
    
    //MARK: Basic Infomation
    @State private var photoURL = URL(string: "")
    @State private var nickName = ""
    @State private var nickNameError = false
    @State private var age = ""
    @State private var incorrectAge = false
    
    //MARK: Secured Infomation
    @State private var phoneNumber = ""
    @State private var phoneNumberError = false
    @State private var mail = ""
    @State private var mailError = false
    @State private var password = ""
    @State private var passwordError = false
    
    var body: some View {
        NavigationView{
            TrackableScrollView(offsetChanged: {offset in
                contentOffset = offset.y
                // print("contentOffset", contentOffset)
            }){
                userPhotoPicker
                    .padding(.bottom, 30)
                
                basicInformation
                    .padding(.bottom, 30)
                
                securedInformation
            }
            .background(colorScheme == .dark ? Color.black : Color(#colorLiteral(red: 0.949019134, green: 0.9490200877, blue: 0.9705254436, alpha: 1)))
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle(Text("Sign up"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    finishButton
                }
            })
        }
        .onAppear(perform: {
            focusedField = .nickName
        })
        
    }
    
    var cancelButton: some View{
        Button(action: {
            dismissSheet()
        }, label: {
            Text("Cancel")
        })
    }
    
    // FIXME: Finsh Sign up
    var finishButton: some View{
        Button(action: {
            // 先要再次检查各个框是否正确
            if validateUserName(userName: nickName){
                if validatePhone(phoneNumber: phoneNumber){
                    if validateEmail(email: mail){
                        if validatePassword(password: password){
                            userModel.tryToSignUp(photoURL: photoURL,
                                                  username: nickName,
                                                  password: password,
                                                  email: mail,
                                                  phone: phoneNumber,
                                                  age: age)
                            dismissSheet()
                        }else{ // wromg password
                            passwordError.toggle()
                            password = ""
                            focusedField = .password
                        }
                    }else{ // wrong email
                        mailError.toggle()
                        mail = ""
                        focusedField = .mail
                    }
                }else{ // wrong phone number
                    phoneNumberError.toggle()
                    phoneNumber = ""
                    focusedField = .phone
                }
            }else{ // wrong user name
                nickNameError.toggle()
                nickName = ""
                focusedField = .nickName
            }
        }, label: {
            Text("Submit")
        })
            .disabled(nickName == "" || password == "" ||  mail == "" || phoneNumber == "")
    }
    
    var userPhotoPicker: some View{
        VStack {
            Button(action: {
                chosesImgButtonPressed.toggle()
            }, label: {
                if let userImage = image{
                    userImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }else{
                    Circle()
                        .fill(.gray)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }
            })
            Button(action: {
                chosesImgButtonPressed.toggle()
            }, label: {
                Text("Add photo")
                    .font(.footnote)
            })
        }
        .confirmationDialog("Select a Picture", isPresented: $chosesImgButtonPressed, titleVisibility: .hidden) {
            Button("Photo") {
                showCamera.toggle()
            }
            Button("Choose Photo") {
                showImagePicker.toggle()
            }
    }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage){
            UserPhotoPickerView(image: $inputImage, imageURL: $photoURL)
    }
    }
    
    func loadImage(){
        guard let pickedImage = inputImage else { return }
        image = Image(uiImage: pickedImage)
    }
    
    // MARK: Basic Text Field
    var basicInformation: some View{
        VStack(alignment: .leading) {
            Text("Basic Information")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.bottom, -4)
            VStack(alignment: .leading){
                nickNameTextField
                
                Divider()
                    .background(Color.gray.blendMode(.overlay))
                
                ageTextField
                
            }
            .padding(.vertical ,12)
            .padding(.horizontal ,15)
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)) : .white)
            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.clear, lineWidth: 1).blendMode(.overlay))
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .padding(.horizontal, 20)
    }
    // MARK: User Name
    var nickNameTextField: some View{
        HStack{
            Text("Account name")
                .font(.callout)
                .lineLimit(1)
                .frame(width:80, alignment: .leading)
            TextField(LocalizedStringKey("Log in required"), text: $nickName)
                .onSubmit {
                    if !validateUserName(userName: nickName){
                        nickNameError.toggle()
                        nickName = ""
                        focusedField = .nickName
                    }
                }
                .focused($focusedField, equals: .nickName)
                .submitLabel(.next)
        }
        .alert(isPresented: $nickNameError){
            Alert(title: Text("Apologize"),
                  message:Text("Please follow the naming rules\n 1. Start with letter \n 2. Length between 6 and 20"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: User Age
    var ageTextField: some View{
        HStack{
            Text("User Age")
                .font(.callout)
                .frame(width:80, alignment: .leading)
            TextField(LocalizedStringKey("Optional"), text: $age)
                .onSubmit {
                    if age.count > 2{
                        age = ""
                        incorrectAge.toggle()
                        focusedField = .age
                    }
                }
            .focused($focusedField, equals: .age)
            .submitLabel(.next)
        }
        .alert(isPresented: $incorrectAge){
            Alert(title: Text("Apologize"),
                  message: Text("Age can not above 99"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: Secured Text Field
    var securedInformation: some View{
        VStack(alignment: .leading) {
            Text("Secured Information")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.bottom, -4)
            VStack(alignment: .leading){
                phoneNumberTextField
                Divider()
                    .background(Color.gray.blendMode(.overlay))
                
                mailTextField
                Divider()
                    .background(Color.gray.blendMode(.overlay))
                passwordTextField
            }
            .padding(.vertical ,12)
            .padding(.horizontal ,15)
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)) : .white)
            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.clear, lineWidth: 1).blendMode(.overlay))
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
            
            HStack{
                Spacer()
                Image("icon_dataprivacy_2x")
                    .resizable()
                    .frame(width:25, height: 25)
                ZStack(alignment:. trailing) {
                    Text("Sign up with ACRT, you data will only be used for basic functionality in this app.")
                        .font(.caption2)
                    .frame(width:250, height: 50)
                    Button(action: {
                        
                    }, label: {
                        Text("See more...")
                            .font(.caption2)
                    })
                        .offset(x: -10, y: 6)
                }
                .offset(y: 2)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: User Phone
    var phoneNumberTextField: some View{
        HStack{
            Text("Phone Number")
                .font(.callout)
                .frame(width:80, alignment: .leading)
                .lineLimit(1)
            Text("+86")
            TextField(LocalizedStringKey("Required"), text: $phoneNumber)
                .keyboardType(.numberPad)
                .onSubmit {
                    if !validatePhone(phoneNumber: phoneNumber){
                        phoneNumberError.toggle()
                        phoneNumber = ""
                        focusedField = .phone
                    }
                }
                .focused($focusedField, equals: .phone)
                .submitLabel(.next)
            // TODO: Might have problem (only can sent once)
                
        }
        
        .alert(isPresented: $phoneNumberError){
            Alert(title: Text("Apologize"),
                  message: Text("Please input right phone number"),
                  dismissButton: .default(Text("OK")))
        }
        
    }
    
    // MARK: User Email
    var mailTextField: some View{
        HStack{
            Text("Email")
                .font(.callout)
                .frame(width:80, alignment: .leading)
            TextField(LocalizedStringKey("Required"), text: $mail)
                .onSubmit {
                    if !validateEmail(email: mail){
                        mailError.toggle()
                        mail = ""
                        focusedField = .mail
                    }
                }
                .focused($focusedField, equals: .mail)
                .submitLabel(.next)
        }
        .alert(isPresented: $mailError){
            Alert(title: Text("Apologize"),
                  message: Text("Please input right email"),
                  dismissButton: .default(Text("OK")))
        }
    }
    // MARK: User Password
    var passwordTextField: some View{
        HStack{
            Text("Password")
                .font(.callout)
                .frame(width:80, alignment: .leading)
            SecureField("Required", text: $password, prompt: Text("Required"))
                .onSubmit {
                    if !validatePassword(password: password){
                        passwordError.toggle()
                        password = ""
                        focusedField = .password
                    }
                }
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
        }
        .alert(isPresented: $passwordError){
            Alert(title: Text("Apologize"),
                  message: Text("Please follow the password setting rules\n 1. Start with a capital letter \n 2. Length must exceeds 8 digits"),
                  dismissButton: .default(Text("OK")))
        }
    }

}

extension SignUpView{
    private enum Field: Int, CaseIterable {
        case nickName, age, phone, varifyCode, mail, password
    }
    
    private func validatePhone(phoneNumber: String) -> Bool {
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func validateUserName(userName: String) -> Bool {
        let userNameRegex = "^[A-Za-z0-9]{6,20}+$"
        let userNamePredicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
        return userNamePredicate.evaluate(with: userName)
    }
    func validatePassword(password: String) -> Bool {
        let  passWordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        return passWordPredicate.evaluate(with: password)
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
        
        SignUpView()
            .preferredColorScheme(.dark)
    }
}
