//
//  CanvasView.swift
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

struct CanvasView: View {
    // @EnvironmentObject var firebaseDB: FirebaseDB
    @EnvironmentObject var httpManager: HttpAuth
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var arModel: ARViewModel
    
    @State private var showMesh = false
    @State var snapShot = false
    @State var requestNow = true
    
    @StateObject var arObjectLibraryViewModel :ARObjectLibraryViewModel = ARObjectLibraryViewModel()
   
    @Binding var goBack: Bool
    
    var body: some View {
        ZStack{
            ARWorldView(showMesh: $showMesh, takeSnapshootNow: $snapShot)
                .environmentObject(arModel)
                .environmentObject(httpManager)
                .environmentObject(arObjectLibraryViewModel)
                .ignoresSafeArea()
            ToolView(snapShot: $snapShot ,showMesh: $showMesh, goBack: $goBack, coaching: $httpManager.statusLoc)
            
            if arModel.isCoaching == true {
                VStack {
                    CustomCoachingView()
                }
                .background(Color.black.opacity(0.5))
            }
            // TODO: localization Button
        }.onAppear() {
            arModel.isCoaching = true
            DispatchQueue.global(qos: .background).async {
                sleep(1)
                while(httpManager.statusLoc != 1) {
                    if(httpManager.statusLoc == 0) {
                        arModel.RequestLocalization(manager: httpManager)
                    }
                }
                
                while(!arObjectLibraryViewModel.AreModelLibrariesLoaded()) {
                    sleep(1)
                }
                DispatchQueue.main.async {
                    print("arModel isCoaching close")
                    arModel.isCoaching = false
                }
            }
        }
        
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(goBack: .constant(false))
            .environmentObject(ARViewModel())
    }
}

