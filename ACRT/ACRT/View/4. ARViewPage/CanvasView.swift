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
   
    @Binding var goBack: Bool
    
    var body: some View {
        ZStack{
            ARWorldView(showMesh: $showMesh, takeSnapshootNow: $snapShot)
                .environmentObject(arViewModel)
                .environmentObject(httpManager)
                .environmentObject(arObjectLibraryViewModel)
                .ignoresSafeArea()
            ToolView(snapShot: $snapShot ,showMesh: $showMesh, goBack: $goBack, coaching: $coachingViewModel.isCoaching)
            
            if coachingViewModel.isCoaching == true {
                VStack {
                    CustomCoachingView()
                        .environmentObject(coachingViewModel)
                }
                .background(Color.black.opacity(0.5))
            }
            // TODO: localization Button
        }.onAppear() {
            coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel, arObjectLibraryViewModel: arObjectLibraryViewModel)
            
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

