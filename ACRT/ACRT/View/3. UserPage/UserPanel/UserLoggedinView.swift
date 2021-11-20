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
    @Environment(\.dismiss) var dismissUserInfoSheet
    
    var body: some View {
        NavigationView {
            ScrollView{
                profileView
                    .padding(.leading, 10)
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
        HStack(alignment: .center, spacing: 30) {
            userImageView
            
            userInfoView
            
            Spacer()
            
        }
        .padding(.leading)
    }
    
    var userImageView: some View{
        ZStack{
            Image(systemName: "circle.fill")
                .resizable()
                .angularGradientGlow(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1))])
                .frame(width: 90, height: 90)
                .blur(radius: 10)
            Image(uiImage: userModel.userImage == nil ? UIImage(systemName: "person.crop.circle")! : userModel.userImage!)
                .renderingMode(userModel.userImage == nil ? .template : .original)
                .resizable()
                .aspectRatio(contentMode: userModel.userImage == nil ? .fit : .fill)
                .foregroundColor(.gray)
                .opacity(userModel.userImage == nil ? 0.5 : 1.0)
                .frame(width: 90, height: 90)
                .cornerRadius(50)
                .overlay(Circle().stroke(Color.white, lineWidth: 1.0))
        }
    }
    
    var userInfoView: some View{
        VStack(alignment: .leading, spacing: 10){
            Text("\(userModel.userName) 's badge")
                .foregroundColor(.primary)
                .font(.title)
                .bold()
                .lineLimit(1)
            HStack {
                Text(userModel.userAge)
                Text("Let's Change the World!")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
    }

}

struct UserLoggedinView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoggedinView()
            .environmentObject(UserViewModel())
        UserLoggedinView()
            .environmentObject(UserViewModel())
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}
