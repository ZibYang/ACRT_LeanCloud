//
//  CustomCoachingView.swift
//  ACRT_new

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/5.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

// [constantMoving] reference: https://zhuanlan.zhihu.com/p/143415397

import SwiftUI

struct CustomCoachingView: View {
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    @EnvironmentObject var placementSetting : PlacementSetting

    @State var animate: Bool = false
    
    @Binding var goBack: Bool
    var animation: Animation{
        Animation.linear(duration: 2.0)
        .repeatForever()
    }
    
    var body: some View {
        ZStack {
            Color.clear
            VStack(spacing: 50) {
                Text("Slowly move device to locate...")
                    .bold()
                    .font(.title3)
                    .foregroundColor(.gray)
                Image("coachingView")
                    .resizable()
                    .aspectRatio(2, contentMode: .fit)
                    .frame(height: 120)
                    .modifier(transitionEffect(x: animate ? -20 : 20))
            }
            if coachingViewModel.showQuitButton{
                VStack{
                    Text("Current network is not stable")
                        .foregroundColor(.white)
                        .font(.headline)
                    VStack{
                        
                        // MARK: If not sign in
                        Text("Sign in so you can turn into create mode without location")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            withAnimation(Animation.easeInOut(duration: 0.8)){
                                goBack.toggle()
                            }
                        }, label: {
                            Text("Return")
                        })
                            .frame(width: 80, height: 35)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        
                        // MARK: If sign in
                        Button(action: {
                            withAnimation(Animation.easeInOut(duration: 0.8)){
                                coachingViewModel.isCoaching = false
                                placementSetting.isInCreationMode.toggle()
                            }
                        }, label: {
                            Text("Into create mode")
                        })
                            .frame(width: 160, height: 35)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        
                    }
                }
                .padding()
                .offset(y: 190)
            }
            
        }
        .onAppear{
            withAnimation(Animation.easeInOut(duration: 1.0) .repeatForever()){
                self.animate = true
            }
        }
    }
}

struct transitionEffect: GeometryEffect {
    var x: CGFloat = 0

    var animatableData: CGFloat {
        get {
            x
        }
        set {
            x = newValue
        }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: x, y: 0))
    }
}


struct CustomCoachingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CustomCoachingView(goBack: .constant(false))
                .background(.ultraThickMaterial)
        }
        .preferredColorScheme(.dark)
//        ZStack {
//            Color.clear
//                .ignoresSafeArea()
//            CustomCoachingView()
//
//        }
//        .background(.ultraThickMaterial)
    }
}
