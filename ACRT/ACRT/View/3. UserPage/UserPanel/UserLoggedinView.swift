//
//  UserLoggedinView.swift
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

import SwiftUI

struct UserLoggedinView: View {
    @EnvironmentObject var userModel : UserViewModel
    @StateObject var awardModel = AwardModel()
    @State var showEditView = false
    
    @Environment(\.dismiss) var dismissUserInfoSheet
    
    var body: some View {
        NavigationView {
            ScrollView{
                profileView
                    .padding()
                    .padding(.vertical, 30)
                // TODO: User Info
                AwardView()
                    .padding(.leading, 10)
                    .environmentObject(awardModel)
            }
            .toolbar{
                Button(action:{
                    dismissUserInfoSheet()
                }){
                    Text("Finish")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        userModel.tryToLogout()
                        dismissUserInfoSheet()
                    }, label: {
                        Text("Log out")
                            .foregroundColor(.secondary)
                    })
                }
            }
            .navigationTitle("My ART Chest")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var profileView: some View{
        HStack(alignment: .center, spacing: 20) {
            userImageView
            
            
            userInfoView
            
            editButtonView
        }
    }
    
    var userImageView: some View{
        ZStack{
            Image(systemName: "circle.fill")
                .resizable()
                .angularGradientGlow(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1))])
                .frame(width: 70, height: 70)
                .blur(radius: 10)
            Image("user")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .cornerRadius(50)
                .overlay(Circle().stroke(Color.white, lineWidth: 1.0))
        }
    }
    
    var userInfoView: some View{
        VStack(alignment: .leading){
            Text("Zhang Ziyang")
                .foregroundColor(.primary)
                .font(.title)
                .bold()
                .lineLimit(1)
            Text("View Certificates")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
    
    var editButtonView: some View{
        Button(action:{
            showEditView.toggle()
        }, label: {
            ZStack {
                Image(systemName: "rectangle.fill")
                    .resizable()
                    .frame(width: 60, height: 30)
                    .angularGradientGlow(colors: [Color(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))])
                    .blur(radius: 10)
                Text("Edit")
                    .padding(.vertical, 3)
                    .padding(.horizontal, 15)
                    .background(.regularMaterial)
                    .cornerRadius(15)
            }
        })
            .sheet(isPresented: $showEditView, content: {
                Text("Hello world")
            })
    }

}

struct UserLoggedinView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoggedinView()
        
        UserLoggedinView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}
