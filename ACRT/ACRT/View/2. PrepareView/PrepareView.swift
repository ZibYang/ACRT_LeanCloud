//
//  WaitingView.swift
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

// [NavigationView] reference: https://www.hackingwithswift.com/books/ios-swiftui/making-navigationview-work-in-landscape


import SwiftUI

struct PrepareView: View {
    @StateObject var mapModel = MapViewModel()
    
    @State var checkLocationRequest = false
    
    @Binding var introduceAgain: Bool
    
    var body: some View {
        NavigationView{
            List{
                // MARK: Launch Request Section
                Section(header: Text(LocalizedStringKey("Launch Requests"))){
                    locationRequest
                }
            } // List
            .navigationTitle(LocalizedStringKey("Are you ready?"))
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var locationRequest: some View{
        DisclosureGroup(isExpanded: $checkLocationRequest, content: {
            // MapView
            MapView()
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(15)
                .environmentObject(mapModel)
                .onAppear(perform: {
                    mapModel.locationManagerDidChangeAuthorization(mapModel.locationManager)
                    mapModel.locationManager.requestWhenInUseAuthorization()
                })
                
            if mapModel.permissionDenied{
                PermisionDeniedView()
            }
        })
        {
            Text("placeHolder")
        }
    }
    
}

struct PrepareView_Previews: PreviewProvider {
    static var previews: some View {
        PrepareView(introduceAgain: .constant(false))
    }
}
