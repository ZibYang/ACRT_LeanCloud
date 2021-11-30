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
// [Haptic] reference: https://www.hackingwithswift.com/books/ios-swiftui/making-vibrations-with-uinotificationfeedbackgenerator-and-core-haptics
// [Background Color] reference: https://www.reddit.com/r/SwiftUI/comments/k4lthn/swiftui_clear_background_of_form_section/

import SwiftUI
import CoreHaptics
import AVFoundation

struct PrepareView: View {
    @StateObject var mapModel = MapViewModel()
    @StateObject var userModel = UserViewModel()
    @StateObject var coachingViewModel = CoachingViewModel()
    @StateObject var httpManager: HttpAuth = HttpAuth()
    @StateObject var usdzManagerViewModel = USDZManagerViewModel()
    @StateObject var messageModel = MessageViewModel()
    @StateObject var arViewModel = ARViewModel()

    @State var checkLocationRequest = false
    @State var checkLidarDeviceList = false
    @State var checkUserCapability = false
    @State var introduceExporeAndCreate = false
    @State var introduceExpore = false
    
    @State var everythingSetted = false
    @State var everythingIsNotSetYetWarning = false

    @State var audioPlayer: AVAudioPlayer!

    @Binding var introduceAgain: Bool
    @State var introduceLiDAR = false
    private let userDefaults = UserDefaults.standard
    
    var body: some View {
        ZStack(alignment: .top) {
            if userDefaults.bool(forKey: "SkipPrepareView") == true || everythingSetted{
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
//                                .listRowBackground(
//                                    ZStack {
//                                        LinearGradient(gradient: .init(colors: mapModel.permissionDenied ? [Color(UIColor.systemBackground)]: [.green, .blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                                            .blur(radius: mapModel.permissionDenied ? 0 : 15)
//                                })
                        }
                    } // List
                    .navigationTitle(LocalizedStringKey("Are you ready!"))
                } // NavigationView
                .navigationViewStyle(StackNavigationViewStyle())
            }
            withAnimation(Animation.easeInOut(duration: 1.0)) {
                HStack{
                    Spacer()
                    UserCircleView()
                        .offset(x: coachingViewModel.isCoaching ? 200 : 0)
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
        .environmentObject(messageModel)
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
            if arViewModel.capabilitySatisfied == "satisfied"{
                HStack(spacing: 10) {
                    Text("Your devices already equipped with LiDAR")
                    
                    Button(action:{
                        introduceLiDAR.toggle()
                    }, label:{
                        Image(systemName: "questionmark.circle")
                    })
                }
                .sheet(isPresented: $introduceLiDAR){
                    IntroduceLiDARView()
                }
            }else{
                Text("Recommend devices include")
                Link(destination: URL(string: "https://www.apple.com.cn/iphone/")!,
                     label: {
                        EquippedLiDARDevicesView(deviceName: "iPhone 13 Pro series", iconName: "iphone")})
                Link(destination: URL(string: "https://www.apple.com.cn/iphone/")!,
                     label: {
                        EquippedLiDARDevicesView(deviceName: "iPhone 12 Pro series", iconName: "iphone")})
                Link(destination: URL(string: "https://www.apple.com.cn/ipad-pro/")!,
                     label: {
                        EquippedLiDARDevicesView(deviceName: "iPad Pro 12.9-inch 4/5th-generation", iconName: "ipad")})
                Link(destination: URL(string: "https://www.apple.com.cn/ipad-pro/")!,
                     label: {
                        EquippedLiDARDevicesView(deviceName: "iPad Pro 11-inch 2/3th-generation", iconName: "ipad")})
            }
        }){
            IndicatorView(indicatorImageName: arViewModel.indicatorImageName,
                         indicatorTitle: arViewModel.indicatorTitle,
                         indicatorDescriptions: arViewModel.indicatorDescription,
                          satisfied: $arViewModel.capabilitySatisfied)
        }
    }
    
    var userLoginRecommandation: some View{
        DisclosureGroup(isExpanded: $checkUserCapability, content: {
            if userModel.capabilitySatisfied == "satisfied"{
                UserCapabilityView(labelImage: "checkmark.circle",
                                   labelText: "Logged-in user can: explore and create",
                                   buttonTapped: $introduceExporeAndCreate)
            }else{
                UserCapabilityView(labelImage: "exclamationmark.circle",
                                   labelText: "Tourist can: explore",
                                   buttonTapped: $introduceExpore)
            }
        }){
            IndicatorView(indicatorImageName: userModel.indicatorImageName,
                         indicatorTitle: userModel.indicatorTitle,
                         indicatorDescriptions: userModel.indicatorDescription,
                         satisfied: $userModel.capabilitySatisfied)
        }
        .sheet(isPresented: $introduceExpore){
            WhatMeansExploreView()
        }
        .sheet(isPresented: $introduceExporeAndCreate){
            WhatMeansCreateView()
        }
    }
    
    var intoARWorldButton: some View{
        Button(action: {
            if !mapModel.permissionDenied{
                let impact = UINotificationFeedbackGenerator()
                impact.notificationOccurred(.success)
                userDefaults.set(true, forKey: "SkipPrepareView")
                coachingViewModel.isInsideQiushi = mapModel.isInsideQiuShi
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    everythingSetted.toggle()
                }
            }else{
                guard let shutterPath = Bundle.main.url(forResource: "errorBeep.wav", withExtension: nil) else{
                    fatalError("Unable to find tapSound.wav in bundle")
                }
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: shutterPath)
                    let impact = UINotificationFeedbackGenerator()
                    impact.notificationOccurred(.error)
                    audioPlayer.play()
                }catch{
                    print(error.localizedDescription)
                }
                everythingIsNotSetYetWarning.toggle()
            }
            
            print("DEBUG(BCH): comeFromPrepareView")
        }, label: {
            HStack {
                Image(systemName: "arkit")
                    .foregroundColor(mapModel.permissionDenied ? .gray : .blue)
                Text("Into Augmented City Brain New World")
                    .lineLimit(1)
                    .gradientForeground(colors: mapModel.permissionDenied ? [.gray] : [.blue, .purple])
            }
            
        })
        .alert("Requirement not fullfill!", isPresented: $everythingIsNotSetYetWarning){
                Button("Check it again", role: .cancel) {}
        }
    }
    
    var footerButton: some View{
        Button(action: {
            let impactLight = UIImpactFeedbackGenerator(style: .light)
            impactLight.impactOccurred()
            introduceAgain.toggle()
        },label: {
            Text("What is ACRT")
            .foregroundColor(.secondary)
        })
    }
}

extension View {
  func hapticFeedbackOnTap(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
    self.onTapGesture {
      let impact = UIImpactFeedbackGenerator(style: style)
      impact.impactOccurred()
    }
  }

}

struct PrepareView_Previews: PreviewProvider {
    static var previews: some View {
        PrepareView(introduceAgain: .constant(false))
        
        PrepareView(introduceAgain: .constant(false))
            .preferredColorScheme(.dark)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
        
    }
}
