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
    @EnvironmentObject var persistenceManager : PersistenceManagerViewModel
    @Binding var showMesh: Bool
    @Binding var showCamera: Bool
    
    var body: some View {
        
        HStack(spacing: 10) {

            // MARK: show mesh Button
            Button(action: {
                showMesh.toggle()
            }, label:{
                Image(systemName: "square.grid.3x3.square")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
            })
                .contextMenu{
                    Label("Show mesh in reality", systemImage: "square.dashed")
                }
            // MARK: share Button
            Button(action: {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    showCamera.toggle()
                }
            }, label:{
                Image(systemName: showCamera ?  "camera.fill" : "camera")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
            })
                .contextMenu{
                    Label("Take a snap shot", systemImage: "camera.aperture")
                }
            
            // MARK: upload button
            Button(action: {
                persistenceManager.shouldUploadSceneToCloud = true
            }, label:{
                Image(systemName: "icloud.and.arrow.up")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
            })
//                .contextMenu{
//                    Label("Upload objects", systemImage: "square.dashed")
//                }
            
            // MARK: download button
            Button(action: {
                persistenceManager.shouldDownloadSceneFromCloud = true
            }, label:{
                Image(systemName: "icloud.and.arrow.down")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
            })
//                .contextMenu{
//                    Label("Downloads objects", systemImage: "square.dashed")
//                }
        }
    }
}

struct TopToolView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.gray, .black]), center: .center, startRadius: 10, endRadius: 250)
                .ignoresSafeArea()
            TopToolView(showMesh: .constant(false), showCamera: .constant(false))
        }
    }
}
