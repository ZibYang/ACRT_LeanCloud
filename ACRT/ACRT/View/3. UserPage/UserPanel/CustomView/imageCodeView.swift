//
//  imageCodeView.swift
//  ACRT
//
//  Created by 章子飏 on 2021/11/4.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct imageCodeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var userModel: UserViewModel
    
    @State private var phoneVarifiedError = false
    @State private var inputToken = ""
    @Binding var phoneVarified: Bool
    
    let phoneNumber: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(colorScheme == .dark ? Color.black : Color(#colorLiteral(red: 0.949019134, green: 0.9490200877, blue: 0.9705254436, alpha: 1)))
                VStack(alignment: .center) {
                    
                    HStack {
                        Spacer()
                        Text(userModel.codeToken)
                        Spacer()
                    }
                    .frame(height: 50)
                    .padding(.vertical ,12)
                    .padding(.horizontal ,15)
                    .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)) : .white)
                    .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.clear, lineWidth: 1).blendMode(.overlay))
                    .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .padding(.bottom)
                    
                    
                        HStack {
                            Text("Token")
                            TextField(LocalizedStringKey("Required"), text: $inputToken)
                        }
                        .padding(.vertical ,12)
                        .padding(.horizontal ,15)
                        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)) : .white)
                        .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.clear, lineWidth: 1).blendMode(.overlay))
                        .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                        Button(action: {
                            if  userModel.varifyToken(userInputToken: inputToken, catchaToken: userModel.tokenURL){
                                userModel.sendVarifyCode(phoneNumber: phoneNumber)
                                phoneVarified.toggle()
                                dismissSheet()
                            }else {
                                phoneVarifiedError.toggle()
                            }
                        }, label: {
                            HStack {
                                Text("Send")
                                Spacer()
                            }
                        })
                        .padding(.vertical ,12)
                        .padding(.horizontal ,15)
                        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)) : .white)
                        .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.clear, lineWidth: 1).blendMode(.overlay))
                        .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))

                    
                }
                .padding()
                
                .alert(isPresented: $phoneVarifiedError){
                    Alert(title: Text("Apologize"),
                          message: Text("Please input right varify code"),
                      dismissButton: .default(Text("OK")))}
            }
            
            .navigationTitle(LocalizedStringKey("Varify Token"))
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading){
                cancelButton
            }
        })
    }
    
    var cancelButton: some View{
        Button(action: {
            dismissSheet()
        }, label: {
            Text("Cancel")
        })
    }
}

struct imageCodeView_Previews: PreviewProvider {
    static var previews: some View {
        imageCodeView(phoneVarified: .constant(false), phoneNumber: "")
        
        imageCodeView(phoneVarified: .constant(false), phoneNumber: "")
            .preferredColorScheme(.dark)
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}
