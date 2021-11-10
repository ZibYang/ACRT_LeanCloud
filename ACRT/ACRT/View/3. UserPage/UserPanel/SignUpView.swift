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

// [Accessing FocusState's value outside of the body of a View. This will result in a constant Binding of the initial value and will not update.] reference: https://www.pointfree.co/episodes/ep155-swiftui-focus-state
// [keyboard move up] reference: https://stackoverflow.com/questions/56491881/move-textfield-up-when-the-keyboard-has-appeared-in-swiftui
// [keyboardType] reference: https://developer.apple.com/documentation/uikit/uikeyboardtype

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismissSheet
    
    @EnvironmentObject var userModel: UserViewModel
    
    @FocusState private var focusedField: SignUpViewModel.Field?
    
    @StateObject private var signUpViewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            NavigationView{
                TrackableScrollView(offsetChanged: {offset in
                    signUpViewModel.contentOffset = offset.y
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
                signUpViewModel.focusedField = .userName
            })
        }
        
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
            // check all information is correct
            if signUpViewModel.AllInfomationWithNoError(){
                userModel.tryToSignUp(photoURL: signUpViewModel.photoURL,
                                              username: signUpViewModel.userName,
                                              password: signUpViewModel.password,
                                              email: signUpViewModel.email,
                                              phone: signUpViewModel.phoneNumber,
                                              age: signUpViewModel.age)
            }
            
        }, label: {
            Text("Submit")
        })
        .disabled(signUpViewModel.image == nil || signUpViewModel.userName == "" || signUpViewModel.password == "" ||  signUpViewModel.email == "" || signUpViewModel.phoneNumber == "")
        .alert(isPresented: $userModel.signUpError){
            Alert(title: Text(LocalizedStringKey(signUpViewModel.errorTitle)),
                  message:Text(LocalizedStringKey(userModel.message)),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    var userPhotoPicker: some View{
        VStack {
            Button(action: {
                signUpViewModel.chosesImgButtonPressed.toggle()
            }, label: {
                if let userImage = signUpViewModel.image{
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
                signUpViewModel.chosesImgButtonPressed.toggle()
            }, label: {
                Text("Add photo")
                    .font(.footnote)
            })
        }
        .confirmationDialog("Select a Picture", isPresented: $signUpViewModel.chosesImgButtonPressed, titleVisibility: .hidden) {
            Button("Photo") {
                signUpViewModel.showCamera.toggle()
            }
            Button("Choose Photo") {
                signUpViewModel.showImagePicker.toggle()
            }
        }
        .alert(isPresented: $signUpViewModel.showCamera){
            Alert(title: Text("Apologize"),
                  message:Text("Can not use camera yet. This function will active in the near future."),
                  dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $signUpViewModel.showImagePicker, onDismiss: loadImage){
            UserPhotoPickerView(image: $signUpViewModel.inputImage, imageURL: $signUpViewModel.photoURL)
        }
    }
    
    func loadImage(){
        guard let pickedImage = signUpViewModel.inputImage else { return }
        signUpViewModel.image = Image(uiImage: pickedImage)
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
                userNameTextField
                
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
    var userNameTextField: some View{
        HStack{
            Text("Account name")
                .font(.callout)
                .lineLimit(1)
                .frame(width:80, alignment: .leading)
            TextField(LocalizedStringKey("Log in required"), text: $signUpViewModel.userName)
                .onSubmit {
                    signUpViewModel.validateUserName()
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .focused($focusedField, equals: .userName)
                .submitLabel(.next)
                .onChange(of: signUpViewModel.focusedField) { newValue in
                    focusedField = newValue
                }
                
        }
        .alert(isPresented: $signUpViewModel.userNameError){
            Alert(title: Text(LocalizedStringKey(signUpViewModel.errorTitle)),
                  message:Text(LocalizedStringKey(signUpViewModel.userNameErrorMessage)),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: User Age
    var ageTextField: some View{
        HStack{
            Text("User Age")
                .font(.callout)
                .frame(width:80, alignment: .leading)
            TextField(LocalizedStringKey("Optional"), text: $signUpViewModel.age)
                .onSubmit {
                    signUpViewModel.validateAge()
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .focused($focusedField, equals: .age)
                .submitLabel(.next)
                .onChange(of: signUpViewModel.focusedField) { newValue in
                    signUpViewModel.focusedField = newValue
                }
                
        }
        .alert(isPresented: $signUpViewModel.incorrectAge){
            Alert(title: Text(LocalizedStringKey(signUpViewModel.errorTitle)),
                  message: Text(LocalizedStringKey(signUpViewModel.ageErrorMessage)),
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
            
        }
        .padding(.horizontal, 20)
    }
    
    var securityHint: some View{
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

    // MARK: User Phone
    var phoneNumberTextField: some View{
        HStack{
            Text("Phone Number")
                .font(.callout)
                .frame(width:80, alignment: .leading)
                .lineLimit(1)
            Text("+86")
            TextField(LocalizedStringKey("Required"), text: $signUpViewModel.phoneNumber)
                .onSubmit {
                    signUpViewModel.validatePhone()
                }
                .keyboardType(.phonePad)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .focused($focusedField, equals: .phone)
                .submitLabel(.next)
                .onChange(of: signUpViewModel.focusedField) { newValue in
                    signUpViewModel.focusedField = newValue
                }
            // TODO: Might have problem (only can sent once)
                
        }
        
        .alert(isPresented: $signUpViewModel.phoneNumberError){
            Alert(title: Text(LocalizedStringKey(signUpViewModel.errorTitle)),
                  message: Text(LocalizedStringKey(signUpViewModel.phoneErrorMessage)),
                  dismissButton: .default(Text("OK")))
        }
        
    }
    
    // MARK: User Email
    var mailTextField: some View{
        HStack{
            Text("Email")
                .font(.callout)
                .frame(width:80, alignment: .leading)
            TextField(LocalizedStringKey("Required"), text: $signUpViewModel.email)
                .onSubmit {
                    signUpViewModel.validateEmail()
                }
                .keyboardType(.emailAddress)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .focused($focusedField, equals: .mail)
                .submitLabel(.next)
                .onChange(of: signUpViewModel.focusedField) { newValue in
                    signUpViewModel.focusedField = newValue
                }
        }
        .alert(isPresented: $signUpViewModel.emailError){
            Alert(title: Text(LocalizedStringKey(signUpViewModel.errorTitle)),
                  message: Text(LocalizedStringKey(signUpViewModel.emailErrorMessage)),
                  dismissButton: .default(Text("OK")))
        }
    }
    // MARK: User Password
    var passwordTextField: some View{
        HStack{
            Text("Password")
                .font(.callout)
                .frame(width:80, alignment: .leading)
            SecureField("Required", text: $signUpViewModel.password, prompt: Text("Required"))
                .onSubmit {
                    signUpViewModel.validatePassword()
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onChange(of: signUpViewModel.focusedField) { newValue in
                    signUpViewModel.focusedField = newValue
                }
            
        }
        .alert(isPresented: $signUpViewModel.passwordError){
            Alert(title: Text(LocalizedStringKey(signUpViewModel.errorTitle)),
                  message: Text(LocalizedStringKey(signUpViewModel.passwordErrorMessage)),
                  dismissButton: .default(Text("OK")))
        }
    }

}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
        
        SignUpView()
            .preferredColorScheme(.dark)
    }
}
