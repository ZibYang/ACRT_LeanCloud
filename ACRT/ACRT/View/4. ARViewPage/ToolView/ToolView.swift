//
//  ToolView.swift
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

struct ToolView: View {
    @EnvironmentObject var placementSetting : PlacementSetting
    @EnvironmentObject var sceneManager : SceneManagerViewModel
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    @EnvironmentObject var httpManager: HttpAuth
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var usdzManagerViewModel : USDZManagerViewModel

    @State var showBottomView = false
    @State var showCameraButton = false
    
    @Binding var snapShot: Bool
    @Binding var showMesh: Bool
    @Binding var goBack: Bool
    
    @State private var snapshotBackgroundOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .opacity(snapshotBackgroundOpacity)
            
            topToolGroup
            
            leftToolGroup
                    
            snapShotButton
            
            placeModelView
        }
        
    }
    
    var placeModelView: some View{
        VStack{
            Spacer()
            ModelSelectedView()
                .environmentObject(placementSetting)
                .padding()
        }
        .offset(y: placementSetting.isInCreationMode && !showCameraButton ? 0 : 300)
    }
    
    var topToolGroup: some View{
        VStack {
            // MARK: Top tool
            HStack {
                // quit Button
                Button(action: {
                    withAnimation(Animation.easeInOut(duration: 0.8)){
                        goBack.toggle()
                    }
                    sceneManager.ClearWholeAnchors()
                    httpManager.statusLoc = 0
                    print("pressed")
                }, label:{
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                })
                    .padding(.all, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    
                TopToolView(showMesh: $showMesh, showCamera: $showCameraButton)
                    .padding(.all, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .environmentObject(sceneManager)
                
                Spacer()
            }
//            .padding(.top, 10)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .offset(x: coachingViewModel.isCoaching ? -400 : 0)
            Spacer()
        }
    }
    
    var leftToolGroup: some View{
        VStack{
            Spacer()
            // MARK: Left center tool
            HStack {
                LeftToolView()
                    .padding(.all, 5)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10).environmentObject(placementSetting)                
                Spacer()
            }
            .padding(.horizontal)
            .offset(x: coachingViewModel.isCoaching ? -150 : 0)
            HStack {
                relocationButton
                Spacer()
            }
            .padding(.horizontal)
            .offset(x: coachingViewModel.isCoaching ? -150 : 0)
            HStack {
                clearSceneButton
                Spacer()
            }
            .padding(.horizontal)
            .offset(x: coachingViewModel.isCoaching ? -150 : 0)
            Spacer()
            

        }
    }
    
    
    var relocationButton: some View{
        //MARK: relocation Button
        Button(action: {
            httpManager.statusLoc = 0
            placementSetting.isInCreationMode = false
            coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel, usdzManagerViewModel: usdzManagerViewModel)
        }, label:{
            Image(systemName: "location")
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
        })
            .padding(.all, 6)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .contextMenu{
                Label("Locate again", systemImage: "location.circle.fill")
            }
    }
    
    var clearSceneButton: some View{
        //MARK: clear Button
        Button(action: {
            self.sceneManager.ClearCreativeAnchors()
            
        }, label:{
            Image(systemName: "trash")
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
        })
            .padding(.all, 6)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .contextMenu{
                Label("Locate again", systemImage: "trash.circle.fill")
            }
    }
        
    var snapShotButton: some View{
        VStack{
            Spacer()
            // MARK: SnapShot button
            Button(action: {
                snapshotBackgroundOpacity = 1.0
                withAnimation(Animation.easeInOut(duration: 1.0)){
                    snapshotBackgroundOpacity = 0.0
                }
                withAnimation(Animation.easeInOut(duration: 0.8)){
                    snapShot.toggle()
                }
                print("snapshort")
            }, label: {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80, alignment: .center)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.8), lineWidth: 2)
                            .frame(width: 65, height: 65, alignment: .center)
                    )
                    .padding(.bottom)
            })
            .offset(y: showCameraButton ? 0 : 500)
        }
    }
}

struct ToolView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false))
            
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 10, endRadius: 300)
                    .ignoresSafeArea()
                ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false))
            }
            .previewInterfaceOrientation(.landscapeLeft)
            
            ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false))
                .preferredColorScheme(.dark)
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}
