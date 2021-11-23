//
//  LeftToolView.swift
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

struct LeftToolView: View {
    @EnvironmentObject var placementSetting : PlacementSetting
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    @EnvironmentObject var httpManager: HttpAuth
    @Binding var showCameraButton : Bool 
    
    let impactLight = UIImpactFeedbackGenerator(style: .light)

//    @State private var selectedToolName = "Explore"
    
    var body: some View {
        VStack {
            exploreTool
                .contextMenu{
                    Label("Explore the magic world", systemImage: "lightbulb")
                }
            createTool
                .contextMenu{
                    Label("Change the world now", systemImage: "gearshape.2")
                }
        }
    }
    
    var exploreTool: some View{
        Button(action: {
            impactLight.impactOccurred()
            if arViewModel.hasBeenLocalized == false{
                httpManager.statusLoc = 0
                placementSetting.isInCreationMode = false
                showCameraButton = false
                coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel)
            }
            else {
                withAnimation(Animation.easeInOut(duration: 0.5)){
    //                selectedToolName = "Explore"
                    placementSetting.isInCreationMode = false
                }
            }

        }, label:{
            Image(systemName: "magnifyingglass")
                .foregroundColor(placementSetting.isInCreationMode == false ? .blue : .white)
                .frame(width: 40, height: 40)
        })
            .background( .gray .opacity(placementSetting.isInCreationMode == false ? 0.5 : 0.0))
            .cornerRadius(10)
    }
    var createTool: some View{
        Button(action: {
            impactLight.impactOccurred()
            withAnimation(Animation.easeInOut(duration: 0.5)){
//                selectedToolName = "Create"
                placementSetting.isInCreationMode = true
            }
            
        }, label:{
            Image(systemName: "cube")
                .foregroundColor(placementSetting.isInCreationMode == true ? .blue : .white)
                .frame(width: 40, height: 40)
        })
            .background( .gray .opacity(placementSetting.isInCreationMode == true ? 0.5 : 0.0))
            .cornerRadius(10)
    }
    
    
    
}

struct LeftsideToolView_Previews: PreviewProvider {
    static var previews: some View {
        LeftToolView(showCameraButton: .constant(false))
            .background(.ultraThinMaterial)
    }
}
