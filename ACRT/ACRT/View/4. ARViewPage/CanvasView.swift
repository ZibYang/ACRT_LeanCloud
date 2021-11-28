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
    
    @StateObject var placementSetting = PlacementSetting()
    @StateObject var sceneManager = SceneManagerViewModel()
    @StateObject var modelDeletionManager = ModelDeletionManagerViewModel()
    @StateObject var persistence: PersistenceHelperViewModel = PersistenceHelperViewModel()
    
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    @EnvironmentObject var httpManager : HttpAuth
    @EnvironmentObject var usdzManagerViewModel : USDZManagerViewModel
    @EnvironmentObject var messageModel: MessageViewModel
    
    @State var showOcclusion = false
    @State private var showMesh = false
    @State var snapShot = false
    @State var requestNow = true
    @State var showQuitButton = false

    @Binding var goBack: Bool
    @State var showModelPicker = false
    
    var body: some View {
        ZStack{
            ARWorldView(showMesh: $showMesh, takeSnapshootNow: $snapShot, showOcclusion: $showOcclusion)
                .environmentObject(arViewModel)
                .environmentObject(httpManager)
                .environmentObject(usdzManagerViewModel)
                .environmentObject(placementSetting)
                .environmentObject(sceneManager)
                .environmentObject(modelDeletionManager)
                .environmentObject(userModel)
                .environmentObject(messageModel)
                .environmentObject(persistence)
                .ignoresSafeArea()
                .onTapGesture(count: 1) {
                }
            ToolView(snapShot: $snapShot ,showMesh: $showMesh, showOcclusion: $showOcclusion, goBack: $goBack)
                .environmentObject(placementSetting)
                .environmentObject(sceneManager)
                .environmentObject(coachingViewModel)
                .environmentObject(httpManager)
                .environmentObject(modelDeletionManager)
                .environmentObject(persistence)

            if coachingViewModel.isCoaching == true {
                VStack {
                    CustomCoachingView(goBack: $goBack)
                        .environmentObject(coachingViewModel)
                        .environmentObject(placementSetting)
                        .environmentObject(userModel)
                }
                .background(Color.black.opacity(0.5))
            }
            
            
            if messageModel.isMessaging == true {
                MessageView()
                    .environmentObject(messageModel)
            }
            
            
        }
        .statusBar(hidden: true)
        .onAppear() {
            httpManager.statusLoc = 0
            coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel)
            // TODO: localization Button
        }
        .halfSheet(showSheet: $placementSetting.openModelList){
            ModelPickerView()
                .environmentObject(placementSetting)
                .environmentObject(usdzManagerViewModel)
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(goBack: .constant(false))
            .environmentObject(UserViewModel())
            .environmentObject(ARViewModel())
            .environmentObject(HttpAuth())
            .environmentObject(CoachingViewModel())
            .environmentObject(PlacementSetting())
            .environmentObject(SceneManagerViewModel())
            .environmentObject(ModelDeletionManagerViewModel())
    }
}

