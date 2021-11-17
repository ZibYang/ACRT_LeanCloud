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
    @StateObject var usdzManagerViewModel = USDZManagerViewModel()
    
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    @EnvironmentObject var httpManager: HttpAuth
    @EnvironmentObject var placementSetting:PlacementSetting
    @EnvironmentObject var sceneManager:SceneManagerViewModel
    @EnvironmentObject var modelDeletionManager:ModelDeletionManagerViewModel

    @State private var showMesh = false
    @State var snapShot = false
    @State var requestNow = true
    @State var showQuitButton = false

    @Binding var goBack: Bool
    @State var showModelPicker = false
    
    var body: some View {
        ZStack{
            ARWorldView(showMesh: $showMesh, takeSnapshootNow: $snapShot, userName: "BCH")
                .environmentObject(arViewModel)
                .environmentObject(httpManager)
                .environmentObject(usdzManagerViewModel)
                .environmentObject(placementSetting)
                .environmentObject(sceneManager)
                .environmentObject(modelDeletionManager)
                .ignoresSafeArea().onTapGesture(count: 1) {
//                    let modelAnchor = ModelAnchor(modelName: "hand", transform: nil, anchorName: nil)
//                    self.placementSetting.modelConfirmedForPlacement.append(modelAnchor)
////                        self.placementSetting.selectedModel = nil
                }
            ToolView(snapShot: $snapShot ,showMesh: $showMesh, goBack: $goBack)
                .environmentObject(placementSetting)
                .environmentObject(sceneManager)
                .environmentObject(coachingViewModel)
                .environmentObject(httpManager)
                .environmentObject(usdzManagerViewModel)

            if coachingViewModel.isCoaching == true {
                VStack {
                    CustomCoachingView(goBack: $goBack)
                        .environmentObject(coachingViewModel)
                        .environmentObject(placementSetting)
                }
                .background(Color.black.opacity(0.5))
            }
        }
        .statusBar(hidden: true)
        .onAppear() {
            coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel, usdzManagerViewModel: usdzManagerViewModel)
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

