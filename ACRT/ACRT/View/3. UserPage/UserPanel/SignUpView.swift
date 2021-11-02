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
    @Environment(\.dismiss) var dismissSheet
    @FocusState private var focusedField: Field?
    @State private var contentOffset = CGFloat(0)
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    @State private var chosesImgButtonPressed = false
    @State private var showCamera = false
    @State private var showImagePicker = false
    
    //MARK: Basic Infomation
    @State private var nickName = ""
    @State private var gender = [ "Unknow", "Female", "Male", "Intersex", "Trans", "NonConforming", "Personal", "Eunuch"]
    @State private var selectedGender = "Unknow"
    
    //MARK: Secured Infomation
    @State private var phoneNumber = ""
    @State private var mail = ""
    @State private var password = ""
    
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
            dismissSheet()
        }, label: {
            Text("Finish")
        })
            .disabled(mail == "" && password == "")
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
            UserPhotoPickerView(image: $inputImage)
    }
    }
    
    func loadImage(){
        guard let pickedImage = inputImage else { return }
        image = Image(uiImage: pickedImage)
    }
    
    var basicInformation: some View{
        VStack(alignment: .leading) {
            Text("Basic Information")
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.bottom, -5)
            VStack(alignment: .leading){
                nickNameTextField
                
                Divider()
                    .background(Color.white.blendMode(.overlay))
                
                genderPicker
                
                Divider()
                    .background(Color.white.blendMode(.overlay))
                
                Text("PlaceHolder")
            }
            .padding(16)
            .background(Color("Background 1"))
            .background(.ultraThinMaterial)
            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.white, lineWidth: 1).blendMode(.overlay))
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .padding(.horizontal, 20)
    }
    
    var nickNameTextField: some View{
        HStack{
            Text("Nick Name")
                .font(.body)
                .frame(width:100, alignment: .leading)
            TextField(LocalizedStringKey("Nick Name"), text: $nickName)
                .focused($focusedField, equals: .nickName)
                .submitLabel(.next)
        }
    }
    
    var genderPicker: some View{
        HStack{
            Text("User Gender")
                .font(.body)
                .frame(width:100, alignment: .leading)
            Picker("Please choose a gender", selection: $selectedGender) {
                ForEach(gender, id: \.self) {
                    Text($0)
                }
            }
            .focused($focusedField, equals: .gender)
            .submitLabel(.next)
        }
    }
    
    var securedInformation: some View{
        VStack(alignment: .leading) {
            Text("Secured Information")
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.bottom, -5)
            VStack(alignment: .leading){
                phoneNumberTextField
                Divider()
                    .background(Color.white.blendMode(.overlay))
                mailTextField
                Divider()
                    .background(Color.white.blendMode(.overlay))
                passwordTextField
                Divider()
                    .background(Color.white.blendMode(.overlay))
                
                Text("PlaceHolder")
                
            }
            .padding(16)
            .background(Color("Background 1"))
            .background(.ultraThinMaterial)
            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.white, lineWidth: 1).blendMode(.overlay))
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .padding(.horizontal, 20)
    }
    
    var phoneNumberTextField: some View{
        HStack{
            Text("Phone")
                .font(.body)
                .frame(width:100, alignment: .leading)
            TextField(LocalizedStringKey("Phone Number"), text: $phoneNumber)
                .focused($focusedField, equals: .phone)
                .submitLabel(.next)
        }
    }
    
    var mailTextField: some View{
        HStack{
            Text("Email")
                .font(.body)
                .frame(width:100, alignment: .leading)
            TextField(LocalizedStringKey("Email Address"), text: $mail)
                .focused($focusedField, equals: .mail)
                .submitLabel(.next)
        }
    }
    
    var passwordTextField: some View{
        HStack{
            Text("Password")
                .font(.body)
                .frame(width:100, alignment: .leading)
            SecureField("Required", text: $password, prompt: Text("Required"))
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
        }
    }

}

extension SignUpView{
    private enum Field: Int, CaseIterable {
        case nickName, gender, phone, mail, password
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
        
        SignUpView()
            .preferredColorScheme(.dark)
    }
}
