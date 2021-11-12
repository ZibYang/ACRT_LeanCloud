//
//  CanvasView.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/5.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

import SwiftUI

struct CanvasView: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    
    @State private var showMesh = false
    @State var snapShot = false
    @State var requestNow = true
    @State var showQuitButton = false
    
    @StateObject var httpManager: HttpAuth = HttpAuth()
    @StateObject var usdzManagerViewModel : USDZManagerViewModel = USDZManagerViewModel()
    @StateObject var placementSetting = PlacementSetting()
    @StateObject var persistenceManager = PersistenceManagerViewModel()
   
    @Binding var goBack: Bool
    
    var body: some View {
        ZStack{
            ARWorldView(showMesh: $showMesh, takeSnapshootNow: $snapShot, userName: "BCH")
                .environmentObject(arViewModel)
                .environmentObject(httpManager)
                .environmentObject(usdzManagerViewModel)
                .environmentObject(placementSetting)
                .environmentObject(persistenceManager)
                .ignoresSafeArea().onTapGesture(count: 1) {
                    let modelAnchor = ModelAnchor(modelName: "hello", transform: nil, anchorName: nil)
                    self.placementSetting.modelConfirmedForPlacement.append(modelAnchor)
//                        self.placementSetting.selectedModel = nil
                }
            ToolView(snapShot: $snapShot ,showMesh: $showMesh, goBack: $goBack, coaching: $coachingViewModel.isCoaching)
                .environmentObject(placementSetting)
                .environmentObject(persistenceManager)
            
            if coachingViewModel.isCoaching == true {
                VStack {
                    CustomCoachingView()
                        .environmentObject(coachingViewModel)
                        .environmentObject(placementSetting)
                }
                .background(Color.black.opacity(0.5))
            }
            // TODO: localization Button
        }.onAppear() {
            coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel, usdzManagerViewModel: usdzManagerViewModel)
        }
        
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(goBack: .constant(false))
            .environmentObject(ARViewModel())
            .environmentObject(HttpAuth())
            .environmentObject(UserViewModel())
    }
}

