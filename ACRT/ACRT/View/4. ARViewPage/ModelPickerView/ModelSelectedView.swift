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
// [StringSeparate] reference: https://www.hackingwithswift.com/example-code/strings/how-to-split-a-string-into-an-array-componentsseparatedby

import SwiftUI

struct ModelSelectedView: View {
    @EnvironmentObject var placementSetting : PlacementSetting
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        HStack(spacing: 30) {
            if placementSetting.selectedModel == ""{
                Button(action: {
                    impactLight.impactOccurred()
                    placementSetting.openModelList = true
                }, label: {
                    ZStack{
                        Image("questionMark_dark")
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(width:120)
                    }
                })
            }else{
                Button(action: {
                    impactLight.impactOccurred()
                    placementSetting.openModelList = true
                }, label: {
                    ZStack{
                        Image(placementSetting.selectedModel.components(separatedBy: ".")[0])
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(width:120)
                    }
                })
                VStack(alignment: .center) {
                    placeButton
                
                    HintText
                }
            }
        }
    }
    
    var HintText: some View{
        HStack() {
            Text("Hint: long press model to delet or ")
            Image(systemName: "trash.square.fill")
        }
        .font(.caption)
        .foregroundColor(.gray)
        .cornerRadius(10)
    }
    
    var placeButton: some View{
        Button(action: {
            impactLight.impactOccurred()
            let modelAnchor = ModelAnchor(modelName: placementSetting.selectedModel, transform: nil, anchorName: nil)
            print("DEBUG(BCH): append \(modelAnchor.model.modelName)")

            self.placementSetting.modelWaitingForPlacement.append(modelAnchor)
//                        self.placementSetting.selectedModel = nil
        }, label: {
            HStack {
                Text("Place")
                    .gradientForeground(colors: placementSetting.selectedModel == "" ? [.gray] : [.blue, .green])
                Image(systemName: "circle.circle")
                    .foregroundColor(placementSetting.selectedModel == "" ? .gray : .green)
            }
        })
            .disabled(placementSetting.selectedModel == "")
            .frame(width: 100,height: 45)
            .background(.white
                            .opacity(0.3))
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
