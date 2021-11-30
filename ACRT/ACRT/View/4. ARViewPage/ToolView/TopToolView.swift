//
//  TopToolView.swift
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

struct TopToolView: View {
    @EnvironmentObject var sceneManager : SceneManagerViewModel
    @Binding var showMesh: Bool
    @Binding var showCamera: Bool
    @Binding var showOcclusion: Bool
    
    @Binding var showHint: Bool
    @Binding var hintMessage: String
    @Binding var hintBackground: Color
    @Binding var showHintTimeRemaining: Int
    
    @State private var cameraHint = false
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        
        HStack(spacing: 10) {
            // MARK: show occlusion Button
            Button(action: {
                impactLight.impactOccurred()
                showOcclusion.toggle()
                withAnimation(Animation.easeInOut){
                    showHint = true
                    if showOcclusion{
                        hintBackground = .green
                        hintMessage = "Occlusion turn on"
                        showHintTimeRemaining = 3
                    }else{
                        hintBackground = .gray
                        hintMessage = "Occlusion turn off"
                        showHintTimeRemaining = 3
                    }
                }
            }, label: {
                Image(showOcclusion ? "occlusion_pick" : "occlusion_unpick")
                    .resizable()
                    .foregroundColor(showOcclusion ? .green : .white)
                    .frame(width: 18, height: 18)
            })
                .contextMenu{
                    Label("Occlusion is the key for AR scene.", systemImage: "building.2.crop.circle.fill")
                }
            // MARK: show mesh Button
            Button(action: {
                if showCamera{
                    let impact = UINotificationFeedbackGenerator()
                    impact.notificationOccurred(.error)
                    cameraHint.toggle()
                }else{
                    impactLight.impactOccurred()
                    showMesh.toggle()
                    withAnimation(Animation.easeInOut){
                        showHint = true
                        if showMesh{
                            hintBackground = .blue
                            hintMessage = "Mesh turn on"
                            showHintTimeRemaining = 3
                        }else{
                            hintBackground = .gray
                            hintMessage = "Mesh turn off"
                            showHintTimeRemaining = 3
                        }
                    }
                }
            }, label:{
                Image(systemName: "square.grid.3x3.square")
                    .foregroundColor(showMesh ? .blue : .white)
                    .frame(width: 30, height: 30)
            })
                .contextMenu{
                    Label("Show mesh in reality", systemImage: "square.dashed")
                }
            // MARK: camera Button
            Button(action: {
                if showMesh{
                    let impact = UINotificationFeedbackGenerator()
                    impact.notificationOccurred(.error)
                    cameraHint.toggle()
                }else{
                    impactLight.impactOccurred()
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        showCamera.toggle()
                        withAnimation(Animation.easeInOut){
                            showHint = true
                            if showCamera{
                                hintBackground = .orange
                                hintMessage = "Camera turn on"
                                showHintTimeRemaining = 3
                            }else{
                                hintBackground = .gray
                                hintMessage = "Camera turn off"
                                showHintTimeRemaining = 3
                            }
                        }
                    }
                }
            }, label:{
                Image(systemName: showCamera ?  "camera.fill" : "camera")
                    .foregroundColor(showCamera ? .orange : .white)
                    .frame(width: 30, height: 30)
            })
                .contextMenu{
                    Label("Take a snap shot", systemImage: "camera.aperture")
                }
        }
        .alert("It is not recommended to take pictures with mesh", isPresented: $cameraHint){
            Button(role: .none){
                impactLight.impactOccurred()
            }label:{
                Text("Keep it that way")
            }
            Button(role: .cancel){
                impactLight.impactOccurred()
                if showCamera{
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        showCamera = false
                    }
                    showMesh = true
                    withAnimation(Animation.easeInOut){
                        showHint = true
                        hintBackground = .blue
                        hintMessage = "Mesh turn on"
                        showHintTimeRemaining = 3
                    }
                }else{
                    showMesh = false
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        showCamera = true
                        withAnimation(Animation.easeInOut){
                            showHint = true
                            hintBackground = .orange
                            hintMessage = "Camera turn on"
                            showHintTimeRemaining = 3
                        }
                    }
                }
            }label:{
                Text(showCamera ? "Show the mesh anyway" : "Turn off the mesh")
            }
        }
    }
}

struct TopToolView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.gray, .black]), center: .center, startRadius: 10, endRadius: 250)
                .ignoresSafeArea()
            TopToolView(showMesh: .constant(false), showCamera: .constant(false), showOcclusion: .constant(true), showHint: .constant(false), hintMessage: .constant(""), hintBackground: .constant(Color.clear), showHintTimeRemaining: .constant(0))
        }
    }
}
