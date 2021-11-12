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
    @StateObject var arObjectLibraryViewModel :ARObjectLibraryViewModel = ARObjectLibraryViewModel()
    @StateObject var placementSetting = PlacementSetting()
   
    @Binding var goBack: Bool
    @State var showModelPicker = false
    var body: some View {
        ZStack{
            ARWorldView(showMesh: $showMesh, takeSnapshootNow: $snapShot)
                .environmentObject(arViewModel)
                .environmentObject(httpManager)
                .environmentObject(arObjectLibraryViewModel)
                .environmentObject(placementSetting)
                .ignoresSafeArea().onTapGesture(count: 1) {
                    placementSetting.doPlaceModel = true
                }
            ToolView(snapShot: $snapShot ,showMesh: $showMesh, goBack: $goBack, coaching: $coachingViewModel.isCoaching)
                .environmentObject(placementSetting)
            
            if coachingViewModel.isCoaching == true {
                VStack {
                    CustomCoachingView(goBack: $goBack)
                        .environmentObject(coachingViewModel)
                        .environmentObject(placementSetting)
                }
                .background(Color.black.opacity(0.5))
            }
            if placementSetting.isInCreationMode{
                VStack{
                    Spacer()
                    ModelSelectedView(modelName: "love_white")
                }
                .padding()
            }
        }
        
        .onAppear() {
            coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel, arObjectLibraryViewModel: arObjectLibraryViewModel)
        }
        .halfSheet(showSheet: $placementSetting.openModelList){
            ModelPickerView()
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

