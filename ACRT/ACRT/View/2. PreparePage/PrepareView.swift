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
    @StateObject var userModel = UserViewModel()
    @StateObject var arViewModel = ARViewModel()
    @StateObject var coachingViewModel = CoachingViewModel()
    @StateObject var httpManager: HttpAuth = HttpAuth()
    @StateObject var usdzManagerViewModel : USDZManagerViewModel = USDZManagerViewModel()
    @StateObject var placementSetting = PlacementSetting()
    @StateObject var sceneManager = SceneManagerViewModel()
    @StateObject var modelDeletionManager = ModelDeletionManagerViewModel()


    
    @State var checkLocationRequest = false
    @State var checkLidarDeviceList = false
    @State var checkUserCapability = false
    @State var introduceExporeAndCreate = false
    @State var introduceExpore = false
    
    @State var everythingSetted = false
    @State var everythingIsNotSetYetWarning = false
    
    @Binding var introduceAgain: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            if everythingSetted{
                CanvasView(goBack: $everythingSetted)
            }else {
                NavigationView{
                    List{
                        // MARK: Launch Request Section
                        Section(header: Text(LocalizedStringKey("Launch Requests"))){
                            locationRequest
                        }
                        // MARK: Recommendation
                        Section(header: Text(LocalizedStringKey("Recommendations"))){
                            useLidarDeviceRecommandation
                            userLoginRecommandation
                        }
                        Section(footer: footerButton){
                            intoARWorldButton
                        }
                    } // List
                    .navigationTitle(LocalizedStringKey("Are you ready?"))
                } // NavigationView
                .navigationViewStyle(StackNavigationViewStyle())
            }
            withAnimation(Animation.easeInOut(duration: 1.0)) {
                HStack{
                    Spacer()
                    UserCircleView()
                        .offset(x: coachingViewModel.isCoaching ? 70 : 0)
                        .padding(.top)
                }
                .padding(.trailing)
            }
        } // ZStack
        .environmentObject(userModel)
        .environmentObject(arViewModel)
        .environmentObject(coachingViewModel)
        .environmentObject(httpManager)
        .environmentObject(usdzManagerViewModel)
        .environmentObject(placementSetting)
        .environmentObject(sceneManager)
        .environmentObject(modelDeletionManager)
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
            IndicatorView(indicatorImageName: mapModel.indicatorImageName,
                         indicatorTitle: mapModel.indicatorTitle,
                         indicatorDescriptions: mapModel.indicatorDescription,
                         satisfied: $mapModel.capabilitySatisfied)
        }
    }
    
    var useLidarDeviceRecommandation: some View{
        DisclosureGroup(isExpanded: $checkLidarDeviceList, content: {
            Text("Recommend devices include")
            EquippedLiDARDevicesView(deviceName: "iPhone 13 Pro series", iconName: "iphone")
            EquippedLiDARDevicesView(deviceName: "iPhone 12 Pro series", iconName: "iphone")
            EquippedLiDARDevicesView(deviceName: "iPad Pro 12.9-inch 4/5th-generation", iconName: "ipad")
            EquippedLiDARDevicesView(deviceName: "iPad Pro 11-inch 2/3th-generation", iconName: "ipad")
        }){
            IndicatorView(indicatorImageName: arViewModel.indicatorImageName,
                         indicatorTitle: arViewModel.indicatorTitle,
                         indicatorDescriptions: arViewModel.indicatorDescription,
                          satisfied: $arViewModel.capabilitySatisfied)
        }
    }
    
    var userLoginRecommandation: some View{
        DisclosureGroup(isExpanded: $checkUserCapability, content: {
            UserCapabilityView(labelImage: "checkmark.circle",
                               labelText: "Logged-in user can:",
                               buttonText: "explore and create",
                               capabilityLevel: $userModel.capabilitySatisfied,
                               buttonTapped: $introduceExporeAndCreate)
                    
            UserCapabilityView(labelImage: "exclamationmark.circle",
                               labelText: "Tourist can:",
                               buttonText: "explore",
                               capabilityLevel: $userModel.capabilitySatisfied,
                               buttonTapped: $introduceExporeAndCreate)
            
        }){
            IndicatorView(indicatorImageName: userModel.indicatorImageName,
                         indicatorTitle: userModel.indicatorTitle,
                         indicatorDescriptions: userModel.indicatorDescription,
                          satisfied: $userModel.capabilitySatisfied)
        }
        .sheet(isPresented: $introduceExpore){
            WhatMeansExporeView()
        }
        .sheet(isPresented: $introduceExporeAndCreate){
            WhatMeansCreateView()
        }
    }
    
    var intoARWorldButton: some View{
        Button(action: {
            if !mapModel.permissionDenied{
                everythingSetted.toggle()
                // TODO: And model loaded
                
            }else{
                everythingIsNotSetYetWarning.toggle()
            }
        }, label: {
            HStack {
                Image(systemName: "arkit")
                    .foregroundColor(mapModel.permissionDenied ? .gray : .blue)
                Text("Into Augmented City Brain New World")
                    .gradientForeground(colors: mapModel.permissionDenied ?  [.gray] : [.blue, .purple])
            }
        })
        .alert("Requirement not fullfill!", isPresented: $everythingIsNotSetYetWarning){
                Button("Check it again", role: .cancel) {}
        }
    }
    
    var footerButton: some View{
        Button(action: {
            introduceAgain.toggle()
            
        },label: {
            Text("What is ACRT")
            .foregroundColor(.secondary)
        })
    }
}

struct PrepareView_Previews: PreviewProvider {
    static var previews: some View {
        PrepareView(introduceAgain: .constant(false))
    }
}
