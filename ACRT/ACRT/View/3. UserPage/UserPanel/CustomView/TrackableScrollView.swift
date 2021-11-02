//
//  TrackableScrollView.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/1.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//


import SwiftUI

struct TrackableScrollView<Content: View>: View {
    let axes: Axis.Set
    let offsetChanged: (CGPoint) -> Void
    let content: Content
    
    init(axes: Axis.Set = .vertical, offsetChanged: @escaping (CGPoint) -> Void = { _ in}, @ViewBuilder content: () -> Content){
        self.axes = axes
        self.offsetChanged = offsetChanged
        self.content = content()
    }
    var body: some View {
        SwiftUI.ScrollView(axes){
            GeometryReader { geometry in
                Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scrollView")).origin)
            }
            .frame(width: 0, height: 0) // get rid off the padding
            content
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey{
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint){}
}

