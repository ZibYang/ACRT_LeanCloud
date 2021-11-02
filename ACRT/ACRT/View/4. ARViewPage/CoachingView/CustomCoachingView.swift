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
    @State var animate: Bool = false
    var animation: Animation{
        Animation.linear(duration: 2.0)
        .repeatForever()
    }
    var body: some View {
        ZStack {
            Color.clear
            VStack(spacing: 50) {
                Text("Move Device to locate")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.gray)
                Image("coachingView")
                    .resizable()
                    .aspectRatio(2, contentMode: .fit)
                    .frame(height: 120)
                .modifier(transitionEffect(x: animate ? -20 : 20))
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
            CustomCoachingView()
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
