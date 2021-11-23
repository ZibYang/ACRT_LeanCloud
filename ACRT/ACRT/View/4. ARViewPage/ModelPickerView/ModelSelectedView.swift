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
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                impactLight.impactOccurred()
                placementSetting.openModelList = true
            }, label: {
                ZStack{
                    Image(placementSetting.selectedModel == "" ? "questionMark_dark" : placementSetting.selectedModel)
                        .resizable()
                        .aspectRatio(1/1, contentMode: .fit)
                        .frame(width:100)
                }
            })
            HStack() {
                placeButton
            
                HintText
            }
        }
    }
    
    var HintText: some View{
        HStack() {
            Text("Long press or ")
                .font(.caption)
            Image(systemName: "trash.square.fill")
        }
        .frame(height: 45)
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    var placeButton: some View{
        Button(action: {
            impactLight.impactOccurred()
            let modelAnchor = ModelAnchor(modelName: placementSetting.selectedModel, transform: nil, anchorName: nil)
            print("DEBUG(BCH): append \(modelAnchor.modelName)")

            self.placementSetting.modelWaitingForPlacement.append(modelAnchor)
//                        self.placementSetting.selectedModel = nil
        }, label: {
            HStack {
                Text("Place")
                Image(systemName: "circle.circle")
            }
            .font(.caption)
        })
            .disabled(placementSetting.selectedModel == "")
            .frame(width: 80,height: 45)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
    }
}

struct ModelSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ModelSelectedView()
            
            ModelSelectedView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(PlacementSetting())

        
        ModelSelectedView()
            .environmentObject(PlacementSetting())
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
