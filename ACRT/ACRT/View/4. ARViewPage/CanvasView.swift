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
    @EnvironmentObject var httpManager: HttpAuth
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var arModel: ARViewModel
    
    @State private var showMesh = false
    @State var snapShot = false
    @State var requestNow = true
   
    @Binding var goBack: Bool
    
    var body: some View {
        ZStack{
            ARWorldView(showMesh: $showMesh, takeSnapshootNow: $snapShot, httpStatus: $httpManager.statusLoc)
                .environmentObject(arModel)
                .ignoresSafeArea()
            ToolView(snapShot: $snapShot ,showMesh: $showMesh, goBack: $goBack, coaching: $httpManager.statusLoc)
            
            if httpManager.statusLoc != 1 {
                VStack {
                    CustomCoachingView()
                }
                .background(Color.black.opacity(0.5))
            }
            // TODO: localization Button
        }.onAppear() {
            httpManager.statusLoc = 0
            DispatchQueue.global(qos: .background).async {
                sleep(1)
                while(httpManager.statusLoc != 1) {
                    if(httpManager.statusLoc == 0) {
                        arModel.RequestLocalization(manager: httpManager)
                    }
                }
            }
        }
        
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(goBack: .constant(false))
            .environmentObject(ARViewModel())
            .environmentObject(HttpAuth())
            .environmentObject(UserViewModel())
    }
}

