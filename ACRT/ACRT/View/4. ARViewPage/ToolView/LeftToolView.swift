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
            withAnimation(Animation.easeInOut(duration: 0.5)){
//                selectedToolName = "Explore"
                placementSetting.isInCreationMode = false
            }
            

        }, label:{
            Image(systemName: "magnifyingglass")
                .foregroundColor(placementSetting.isInCreationMode == false ? .blue : .white)
                .frame(width: 45, height: 45)
        })
            .background( .gray .opacity(placementSetting.isInCreationMode == false ? 0.5 : 0.0))
            .cornerRadius(10)
    }
    var createTool: some View{
        Button(action: {
            withAnimation(Animation.easeInOut(duration: 0.5)){
//                selectedToolName = "Create"
                placementSetting.isInCreationMode = true
                placementSetting.openModelList = true
            }
            
        }, label:{
            Image(systemName: "cube")
                .foregroundColor(placementSetting.isInCreationMode == true ? .blue : .white)
                .frame(width: 45, height: 45)
        })
            .background( .gray .opacity(placementSetting.isInCreationMode == true ? 0.5 : 0.0))
            .cornerRadius(10)
    }
    
    
    
}

struct LeftsideToolView_Previews: PreviewProvider {
    static var previews: some View {
        LeftToolView()
            .background(.ultraThinMaterial)
    }
}
