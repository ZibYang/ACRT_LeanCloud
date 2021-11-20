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

    var body: some View {
        HStack(spacing: 30) {
            Button(action: {
                placementSetting.openModelList = true
            }, label: {
                ZStack{
                    Image(placementSetting.selectedModel == "" ? "questionMark_dark" : placementSetting.selectedModel)
                        .resizable()
                        .aspectRatio(1/1, contentMode: .fit)
                        .frame(width:100)
                }
            })
            
            placeButton
            
            cancelButton
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
            let modelAnchor = ModelAnchor(modelName: placementSetting.selectedModel, transform: nil, anchorName: nil)
            print("DEBUG(BCH): append \(modelAnchor.modelName)")

            self.placementSetting.modelWaitingForPlacement.append(modelAnchor)
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
            ModelSelectedView()
            ModelSelectedView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(PlacementSetting())
    }
}
