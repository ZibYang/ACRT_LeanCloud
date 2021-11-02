//
//  LeftToolView.swift
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

struct LeftToolView: View {
    @State private var selectedToolName = "Explore"
    
    var body: some View {
        VStack {
            exploreTool
            createTool
        }
    }
    
    var exploreTool: some View{
        Button(action: {
            withAnimation(.spring()){
                selectedToolName = "Explore"
            }
        }, label:{
            Image(systemName: "magnifyingglass")
                .foregroundColor(selectedToolName == "Explore" ? .blue : .white)
                .frame(width: 40, height: 40)
        })
            .background( .gray .opacity(selectedToolName == "Explore" ? 0.5 : 0.0))
            .cornerRadius(10)
    }
    var createTool: some View{
        Button(action: {
            withAnimation(.spring()){
                selectedToolName = "Create"
            }
        }, label:{
            Image(systemName: "cube")
                .foregroundColor(selectedToolName == "Create" ? .blue : .white)
                .frame(width: 40, height: 40)
        })
            .background( .gray .opacity(selectedToolName == "Create" ? 0.5 : 0.0))
            .cornerRadius(10)
    }
    
    
    
}

struct LeftsideToolView_Previews: PreviewProvider {
    static var previews: some View {
        LeftToolView()
    }
}
