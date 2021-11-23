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
    
    @State private var cameraHint = false
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        
        HStack(spacing: 10) {
            // MARK: show occlusion Button
            Button(action: {
                impactLight.impactOccurred()
                showOcclusion.toggle()
            }, label: {
                Image(systemName: showOcclusion ? "building.2.fill" : "building.2")
                    .foregroundColor(showOcclusion ? .green : .white)
                    .frame(width: 30, height: 30)
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
                }
            }, label:{
                Image(systemName: "square.grid.3x3.square")
                    .foregroundColor(showMesh ? .green : .white)
                    .frame(width: 30, height: 30)
            })
                .contextMenu{
                    Label("Show mesh in reality", systemImage: "square.dashed")
                }
            // MARK: share Button
            Button(action: {
                if showMesh{
                    let impact = UINotificationFeedbackGenerator()
                    impact.notificationOccurred(.error)
                    cameraHint.toggle()
                }else{
                    impactLight.impactOccurred()
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        showCamera.toggle()
                    }
                }
            }, label:{
                Image(systemName: showCamera ?  "camera.fill" : "camera")
                    .foregroundColor(.white)
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
                }else{
                    showMesh = false
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        showCamera = true
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
            TopToolView(showMesh: .constant(false), showCamera: .constant(false), showOcclusion: .constant(true))
        }
    }
}
