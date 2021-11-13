//
//  ModelSelectedView.swift
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
//

import SwiftUI

struct ModelSelectedView: View {
    @EnvironmentObject var placementSetting : PlacementSetting

    let modelName : String

    
    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: "square.fill")
                .resizable()
                .background(.ultraThinMaterial)
                .opacity(0.5)
                .frame(width: 100, height: 100)
                .cornerRadius(11)
                .overlay(Image(modelName))
            
            colorPicker
            
            buttonSet
        }
    }
    
    var colorPicker: some View{
        HStack{
            Button(action: {
                
            }, label: {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            })
            Button(action: {
                
            }, label: {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
            })
        }
    }
    
    var buttonSet: some View{
        VStack(spacing: 20){
            cacelButton
            
            placeButton
        }
    }
    
    var cacelButton: some View{
        Button(action: {
            
        }, label: {
            Text("Cancel")
        })
            .frame(width: 80,height: 40)
            .background(.ultraThinMaterial)
            .foregroundColor(.red)
            .cornerRadius(10)
    }
    
    var placeButton: some View{
        Button(action: {
            let modelAnchor = ModelAnchor(modelName: modelName, transform: nil, anchorName: nil)
            self.placementSetting.modelConfirmedForPlacement.append(modelAnchor)
//                        self.placementSetting.selectedModel = nil
        }, label: {
            Text("Place")
        })
            .frame(width: 80,height: 40)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
    }
}

struct ModelSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ModelSelectedView(modelName: "love_white")
            ModelSelectedView(modelName: "love_red")
                .preferredColorScheme(.dark)
        }
    }
}
