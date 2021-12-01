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
    @Environment(\.colorScheme) var colorScheme
    @State private var contentOffset = CGFloat(0)
    
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                TrackableScrollView(offsetChanged: { offsetPoint in
                    contentOffset = offsetPoint.y
                }) {
                    // TODO: User Info
                    AwardView()
                        .padding(.top, 150)
                        .padding(.leading, 10)
                        .environmentObject(awardModel)
                        
                }
                profileView
                    .padding(.leading, 10)
                    .padding(.vertical, 30)
                    .background(.regularMaterial)
            }
            .toolbar{
                Button(action:{
                    impactLight.impactOccurred()
                    dismissUserInfoSheet()
                }){
                    Text("Finish")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        impactLight.impactOccurred()
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
            .preferredColorScheme(.dark)
            .environmentObject(UserViewModel())
        UserLoggedinView()
            .environmentObject(UserViewModel())
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}
