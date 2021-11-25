//
//  UseToolGuidenceView.swift
//  ACRT
//
//  Created by Lab509 on 2021/11/25.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct UseToolGuidenceView: View {
    @State var step = 0
    
    var body: some View {
        ZStack{
            topToolIntroduce
            
            LeftToolIntroduce
            
            controllPannel
            
        }
    }
    
    var controllPannel: some View{
        VStack{
            Spacer()
            HStack(spacing: 30){
                Button(action: {
                    withAnimation(Animation.easeInOut(duration: 0.3)) {
                        step -= 1
                    }
                }, label: {
                    Text("Previous")
                        .foregroundColor(step == 0 ? .gray : .blue)
                })
                    .disabled(step == 0)
                Button(action: {
                    withAnimation(Animation.easeInOut(duration: 0.3)) {
                        step += 1
                    }
                }, label: {
                    Text("Next")
                })
            }
        }
    }
    var topToolIntroduce: some View{
        VStack {
            ZStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Image(systemName: "arrow.backward")
                        .frame(width: 42, height: 42)
                        .background(Material.ultraThinMaterial)
                        .cornerRadius(10)
                    Text("Go back to the menu.")
                        .font(.footnote)
                }
                .offset(x: -114)
                .foregroundColor(.white)
                .opacity(step == 0 ? 1 : 0)
                
                VStack(alignment: .leading) {
                    Image(systemName: "building.2")
                        .frame(width: 42, height: 42)
                        .background(Material.ultraThinMaterial)
                        .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                    Text("Switch occlusion.")
                        .font(.footnote)
                }
                .foregroundColor(.white)
                .offset(x: -76)
                .opacity(step == 1 ? 1 : 0)
                
                VStack(alignment: .leading) {
                    Image(systemName: "square.grid.3x3.square")
                        .frame(width: 42, height: 42)
                        .background(Material.ultraThinMaterial)
                    Text("Show mesh.")
                        .font(.footnote)
                }
                .foregroundColor(.white)
                .offset(x: -46)
                .opacity(step == 2 ? 1 : 0)
                
                VStack(alignment: .leading) {
                    Image(systemName: "camera")
                        .frame(width: 42, height: 42)
                        .background(Material.ultraThinMaterial)
                        .cornerRadius(10, corners: [.topRight, .bottomRight])
                    Text("Take a photo.")
                        .font(.footnote)
                }
                .foregroundColor(.white)
                .offset(x: 3)
                .opacity(step == 3 ? 1 : 0)
                Spacer()
            }
            .padding()
            Spacer()
        }
    }
   
    var LeftToolIntroduce: some View{
        VStack{
            Spacer()
            HStack{
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 40, height: 40)
                            .background(Material.ultraThinMaterial)
                            .cornerRadius(10)
                        Text("Tap it into explore mood which will automaticlly perform localization if user havn't localized.")
                            .font(.footnote)
                    }
                    .offset(x: 2, y: 4)
                    .foregroundColor(.white)
                    .opacity(step == 4 ? 1 : 0)
                    
                    HStack {
                        Image(systemName:  "cube")
                            .frame(width: 40, height: 40)
                            .background(Material.ultraThinMaterial)
                            .cornerRadius(10)
                        Text("Tap it into create mood and it will show the right hand menu as well.")
                            .font(.footnote)
                    }
                    .offset(x: 2, y: -1)
                    .foregroundColor(.white)
                    .opacity(step == 5 ? 1 : 0)
    
                    HStack {
                        Image(systemName:  "location")
                            .frame(width: 44, height: 44)
                            .background(Material.ultraThinMaterial)
                            .cornerRadius(10)
                        Text("Tap it to perform re-location at anytime.")
                            .font(.footnote)
                    }
                    .foregroundColor(.white)
                    .opacity(step == 6 ? 1 : 0)

                }
                
                .padding()
                Spacer()
            }
            Spacer()
        }
    }
}

struct UseToolGuidenceView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ModelSelectedView()
            RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 10, endRadius: 300)
                .ignoresSafeArea()
            ToolView(snapShot: .constant(false),showMesh: .constant(false), showOcclusion: .constant(true), goBack: .constant(false))
            Color.black
                .opacity(0.6)
                
            UseToolGuidenceView()
        }
        .environmentObject(PlacementSetting())
        .environmentObject(SceneManagerViewModel())
        .environmentObject(CoachingViewModel())
        .environmentObject(HttpAuth())
        .environmentObject(ARViewModel())
        .environmentObject(ModelDeletionManagerViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(PersistenceHelperViewModel())
    }
}
