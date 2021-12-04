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

import Foundation
import SwiftUI

struct ModelSelectedView: View {
    @EnvironmentObject var placementSetting : PlacementSetting
    @EnvironmentObject var usdzManagerViewModel : USDZManagerViewModel

    let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    @Binding var showMessageBoardUseHint: Bool
    @State var rotateRadianAroundX: Int = 0
    var body: some View {
        if placementSetting.selectedModel == ""{
            HStack {
                Button(action: {
                    impactLight.impactOccurred()
                    placementSetting.openModelList = true
                    rotateRadianAroundX = 0
                }, label: {
                    ZStack{
                        Image("questionMark_dark")
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(width:120)
                    }
                })
            }
            .padding(.bottom)
        }else{
            HStack(spacing: 30){
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
                    rotationButton
                
                    HintText2
                }
                
                
                VStack(alignment: .center) {
                    placeButton
                
                    HintText1
                }
            }
            .padding(.bottom)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .cornerRadius(15, corners: [.topLeft, .topRight])
        }
    }
       
    
    var HintText1: some View{
        HStack() {
            Text("Hint: long press model to delet or ")
            Image(systemName: "trash.square.fill")
        }
        .font(.caption)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    var HintText2: some View{
        HStack() {
            Text("press to change orientation of model")
        }
        .font(.caption)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    var placeButton: some View{
        Button(action: {
            impactLight.impactOccurred()
            
            self.placementSetting.place(radian: Float(rotateRadianAroundX) * 1.0 / 180.0 * Float.pi, axis: SIMD3<Float>(1,0,0))
            
            
            if placementSetting.selectedModel == "user_text_MessageBoard.reality"{
                showMessageBoardUseHint.toggle()
            }
        }, label: {
            HStack {
                Text("Place")
            }
            .foregroundColor(.white)
        })
            .frame(width: 100,height: 45)
            .background(.blue)
            .cornerRadius(10)
    }
    
    var rotationButton: some View{
        Button(action: {
            if usdzManagerViewModel.createModelList.isModelVerticalToGround(modelName: placementSetting.selectedModel) {
                if rotateRadianAroundX != 0 {
                    rotateRadianAroundX = 0
                } else {
                    rotateRadianAroundX = -90
                }
            } else {
                if rotateRadianAroundX != 0 {
                    rotateRadianAroundX = 0
                } else {
                    rotateRadianAroundX = 90
                }
            }
        }, label: {
            HStack {
               
                Text(((usdzManagerViewModel.createModelList.isModelVerticalToGround(modelName: placementSetting.selectedModel) && rotateRadianAroundX == 0) || (usdzManagerViewModel.createModelList.isModelVerticalToGround(modelName: placementSetting.selectedModel) == false && rotateRadianAroundX != 0)) ?
                     "Vertical" : "Horizontal")
            }
            .foregroundColor(.white)
        })
            .frame(width: 100,height: 45)
            .background(.blue)
            .cornerRadius(10)
    }
}

struct ModelSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ModelSelectedView(showMessageBoardUseHint: .constant(false))
            
            ModelSelectedView(showMessageBoardUseHint: .constant(false))
                .preferredColorScheme(.dark)
        }
        .environmentObject(PlacementSetting())

        
        ZStack {
            ToolView(showCameraButton: .constant(false) ,snapShot: .constant(false),showMesh: .constant(false), showOcclusion: .constant(true),goBack: .constant(false), showGuidence: .constant(false), showMessageBoardUseHint: .constant(false), haveLiDAR: false)
                .environmentObject(PlacementSetting())
                .environmentObject(SceneManagerViewModel())
                .environmentObject(CoachingViewModel())
                .environmentObject(HttpAuth())
                .environmentObject(ARViewModel())
                .environmentObject(ModelDeletionManagerViewModel())
                .environmentObject(UserViewModel())
                .environmentObject(PersistenceHelperViewModel())
                .environmentObject(MessageViewModel())
                
            VStack{
                Spacer()
                ModelSelectedView(showMessageBoardUseHint: .constant(false))
                    .environmentObject(PlacementSetting())
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .preferredColorScheme(.dark)
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
