//
//  UseToolGuidenceView.swift
//  ACRT
//
//  Created by Lab509 on 2021/11/25.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct UseToolGuidenceView: View {
    @Binding var showGuidence: Bool
    @State var step = 0
    
    var body: some View {
        ZStack{
            topToolIntroduce
            
            LeftToolIntroduce
            
            RightToolIntroduce
            
            BottomToolIntroduce
            
            BottomToolIntroduce2
            
            controllPannel
                .padding(.horizontal)
            
        }
    }
    
    var controllPannel: some View{
        VStack{
            Spacer()
            ZStack(alignment: .bottom) {
                HStack {
                    Button(action: {
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: "ShowGuidence")
                        withAnimation(Animation.easeInOut(duration: 0.3)){
                            showGuidence.toggle()
                        }
                    }, label: {
                        Text("Skip")
                    })
                    Spacer()
                }
                .padding()
                HStack(spacing: 30){
                    Spacer()
                    VStack{
                        Button(action: {
                            withAnimation(Animation.easeInOut(duration: 0.3)) {
                                step -= 1
                            }
                        }, label: {
                            Text("Previous")
                                .foregroundColor(step == 0 ? .gray : .blue)
                        })
                            .padding(.bottom)
                            .disabled(step == 0)
                        Button(action: {
                            if step == 11{
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(true, forKey: "ShowGuidence")
                                withAnimation(Animation.easeInOut(duration: 0.3)){
                                    showGuidence.toggle()
                                }
                            }else{
                                withAnimation(Animation.easeInOut(duration: 0.3)) {
                                    step += 1
                                }
                            }
                        }, label: {
                            Text(step == 11 ? "Finish" : "Next")
                        })
                            .padding(.bottom)
                    }
                }
            }
        }
    }
    
    var topToolIntroduce: some View{
        VStack {
            ZStack(alignment: .top) {
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "arrow.backward")
                            .frame(width: 42, height: 42)
                            .background(.gray)
                            .cornerRadius(10)
                        Text("Go back to the menu.")
                            .font(.footnote)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .opacity(step == 0 ? 1 : 0)
                
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "building.2")
                            .frame(width: 42, height: 42)
                            .padding(.horizontal, 3)
                            .background(.gray)
                            .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                        Text("Switch occlusion.")
                            .font(.footnote)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .offset(x: 50)
                .opacity(step == 1 ? 1 : 0)
                
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "square.grid.3x3.square")
                            .frame(width: 42, height: 42)
                            .background(.gray)
                        Text("Show mesh.")
                            .font(.footnote)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .offset(x: 99)
                .opacity(step == 2 ? 1 : 0)
                
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "camera")
                            .frame(width: 42, height: 42)
                            .background(.gray)
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                        Text("Take a photo.")
                            .font(.footnote)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .offset(x: 142)
                .opacity(step == 3 ? 1 : 0)
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
                            .background(.gray)
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
                            .background(.gray)
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
                            .background(.gray)
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
    
    var RightToolIntroduce: some View{
        VStack{
            Spacer()
            HStack{
                VStack(alignment: .trailing) {
                    HStack() {
                        Spacer()
                        Text("Tap it to download the models created by other people, it might be so much fun to find.")
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                        Image(systemName: "icloud.and.arrow.down")
                            .frame(width: 40, height: 40)
                            .background(.gray)
                            .cornerRadius(10)
                    }
                    .foregroundColor(.white)
                    .opacity(step == 7 ? 1 : 0)
                    
                    HStack {
                        Spacer()
                        Text("Tap it to upload your models into the cloud so everyone can see your creation.")
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                        Image(systemName: "icloud.and.arrow.up")
                            .frame(width: 40, height: 40)
                            .background(.gray)
                            .cornerRadius(10)
                    }
                    .foregroundColor(.white)
                    .opacity(step == 8 ? 1 : 0)
                    
                    HStack {
                        Spacer()
                        Text("Tap it to delete every model in the scene, it will save you a lot of time.")
                            .font(.footnote)
                            .multilineTextAlignment(.trailing)
                        Image(systemName: "trash")
                            .frame(width: 40, height: 40)
                            .background(.gray)
                            .cornerRadius(10)
                    }
                    .foregroundColor(.white)
                    .opacity(step == 9 ? 1 : 0)
                }
            }
            .padding(17)
            Spacer()
        }
    }
    
    var BottomToolIntroduce: some View{
        VStack{
            Spacer()
            VStack {
                Text("Tap it to choose the model.")
                    .font(.footnote)
                    .foregroundColor(.white)
                Image("placeHolder")
                    .resizable()
                    .aspectRatio(1/1, contentMode: .fit)
                    .frame(width:120)
            }
            .opacity(step == 10 ? 1 : 0)
            
        }
    }
    
    var BottomToolIntroduce2: some View{
        VStack{
            Spacer()
            VStack {
                Text("Top sign means the model have animation.")
                    .font(.footnote)
                    .foregroundColor(.white)
                Image("placeHolder2")
                    .resizable()
                    .aspectRatio(1/1, contentMode: .fit)
                    .frame(width:120)
            }
            .opacity(step == 11 ? 1 : 0)
            
        }
    }
}

struct UseToolGuidenceView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ModelSelectedView()
            RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 10, endRadius: 300)
                .ignoresSafeArea()
            ToolView(snapShot: .constant(false),showMesh: .constant(false), showOcclusion: .constant(true), goBack: .constant(false), showGuidence: .constant(false))
            Color.black
                .opacity(0.5)
                
            UseToolGuidenceView(showGuidence: .constant(true))
        }
        .environmentObject(PlacementSetting())
        .environmentObject(SceneManagerViewModel())
        .environmentObject(CoachingViewModel())
        .environmentObject(HttpAuth())
        .environmentObject(ARViewModel())
        .environmentObject(ModelDeletionManagerViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(PersistenceHelperViewModel())
        ZStack {
            ModelSelectedView()
            RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 10, endRadius: 300)
                .ignoresSafeArea()
            ToolView(snapShot: .constant(false),showMesh: .constant(false), showOcclusion: .constant(true), goBack: .constant(false), showGuidence: .constant(false))
            Color.black
                .opacity(0.6)
                
            UseToolGuidenceView(showGuidence: .constant(true))
        }
        .previewDevice("iPhone 13")
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
