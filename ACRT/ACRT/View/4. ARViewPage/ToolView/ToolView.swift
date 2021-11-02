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
    @State var showBottomView = false
    @State var showCameraButton = false
    
    @Binding var snapShot: Bool
    @Binding var showMesh: Bool
    @Binding var goBack: Bool
    @Binding var coaching: Int
    
    @State private var snapshotBackgroundOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .opacity(snapshotBackgroundOpacity)
            VStack {
                // MARK: Top tool
                HStack {
                    // quit Button
                    Button(action: {
                        withAnimation(Animation.easeInOut(duration: 1.0)){
                            goBack.toggle()
                        }
                        print("pressed")
                    }, label:{
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                    })
                        .padding(.all, 6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding(.top, 10)
                    TopToolView(showMesh: $showMesh, goBack: $goBack, showCamera: $showCameraButton)
                        .padding(.all, 6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding(.top, 10)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .offset(x: coaching != 1 ? -200 : 0)
                Spacer()
                
                // MARK: Left center tool
                HStack {
                    LeftToolView()
                        .padding(.all, 5)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                    Spacer()
                }
                .padding(.horizontal)
                .offset(x: coaching != 1 ? -150 : 0)
                Spacer()
                
                // MARK: SnapShot button
                Button(action: {
                    snapshotBackgroundOpacity = 1.0
                    withAnimation(Animation.easeInOut(duration: 1.0)){
                        snapshotBackgroundOpacity = 0.0
                    }
                    snapShot.toggle()
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
        
}

struct ToolView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false), coaching: .constant(1))
            
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 10, endRadius: 300)
                    .ignoresSafeArea()
                ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false), coaching: .constant(1))
            }
            .previewInterfaceOrientation(.landscapeLeft)
            
            ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false), coaching: .constant(1))
                .preferredColorScheme(.dark)
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}
