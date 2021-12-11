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
    
    @StateObject var placementSetting = PlacementSetting()
    @StateObject var sceneManager = SceneManagerViewModel()
    @StateObject var modelDeletionManager = ModelDeletionManagerViewModel()
    @StateObject var persistence: PersistenceHelperViewModel = PersistenceHelperViewModel()
    
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    @EnvironmentObject var httpManager : HttpAuth
    @EnvironmentObject var usdzManagerViewModel : USDZManagerViewModel
    @EnvironmentObject var messageModel: MessageViewModel
    
    @State var showOcclusion = false
    @State private var showMesh = false
    @State var snapShot = false
    @State var requestNow = true
    @State var showQuitButton = false
    @State var disableEntity = false
    
    // Into Guidence
    @State var showGuidence = false
    @State var showGuidenceHint = false
    @State var showModelPicker = false
    @State var showMessageBoardUseHint = false
    
    @Binding var goBack: Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        ZStack{
            ARWorldView(showMesh: $showMesh, takeSnapshootNow: $snapShot, disableEntity: $disableEntity, showOcclusion: $showOcclusion)
                .environmentObject(arViewModel)
                .environmentObject(httpManager)
                .environmentObject(usdzManagerViewModel)
                .environmentObject(placementSetting)
                .environmentObject(sceneManager)
                .environmentObject(modelDeletionManager)
                .environmentObject(userModel)
                .environmentObject(messageModel)
                .environmentObject(persistence)
                .environmentObject(coachingViewModel)
                .ignoresSafeArea()
                .onTapGesture(count: 1) {
                }
            ToolView(showCameraButton: $disableEntity, snapShot: $snapShot ,showMesh: $showMesh, showOcclusion: $showOcclusion, goBack: $goBack, showGuidence: $showGuidence, showMessageBoardUseHint: $showMessageBoardUseHint, haveLiDAR: arViewModel.isLiDAREqiped)
                .environmentObject(placementSetting)
                .environmentObject(sceneManager)
                .environmentObject(coachingViewModel)
                .environmentObject(httpManager)
                .environmentObject(modelDeletionManager)
                .environmentObject(persistence)
                .environmentObject(messageModel)

            if coachingViewModel.isCoaching == true {
                VStack {
                    CustomCoachingView(goBack: $goBack, showGuidenceHint: $showGuidenceHint)
                        .environmentObject(coachingViewModel)
                        .environmentObject(placementSetting)
                        .environmentObject(userModel)
                }
                .background(Color.black.opacity(0.5))
            }
            
            
            if messageModel.isMessaging == true {
                MessageView()
                    .environmentObject(placementSetting)
                    .environmentObject(messageModel)
                    .environmentObject(userModel)
            }
            
            Text("").alert(isPresented: $messageModel.showBurgerKing, content: {
                Alert(title: Text("Info:"),
                      message: Text("BurgerKing is on 4th Floor, Enjoy :)"),
                      dismissButton: Alert.Button.default(
                        Text("OK"), action: {
                            messageModel.showBurgerKing = false

                      }
                    )
                )
            })
            
            Text("").alert(isPresented: $messageModel.showKFC, content: {
                Alert(title: Text("Info:"),
                      message: Text("KFC is on 1st Floor, Enjoy :)"),
                      dismissButton: Alert.Button.default(
                        Text("OK"), action: {

                            messageModel.showKFC = false

                      }
                    )
                )
            })
            
            Text("").alert(isPresented: $messageModel.showCoffee, content: {
                Alert(title: Text("Info:"),
                      message: Text("Starbucks is on 3th Floor, Enjoy :)"),
                      dismissButton: Alert.Button.default(
                        Text("OK"), action: {

                            messageModel.showCoffee = false

                      }
                    )
                )
            })
                
            
            
            if showMessageBoardUseHint{
                if userDefaults.bool(forKey: "KnowHowToUseMessageBoard") == false
                {
                    ZStack {
                        Color.black
                            .opacity(0.6)
                            .ignoresSafeArea()
                        VStack(alignment: .center) {
                            HStack{
                                Image(systemName: "hand.tap")
                                Text("Tap the Message Board to leave your message!")
                            }
                            .foregroundColor(.white)
                            .padding()
                            HStack{
                                Button(action: {
                                    showMessageBoardUseHint.toggle()
                                    userDefaults.set(true, forKey: "KnowHowToUseMessageBoard")
                                }, label: {
                                    Text("OK")
                                })
                            }
                        }
                        .padding()
                        .padding(.horizontal)
                    }
                }
            }
            
        }
        .alert("Hello freshman, let's walk you throgh and see how this app work.", isPresented: $showGuidenceHint) {
            Button(role: .none){
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "Guidenceshowed")
            }label:{
                Text("Thanks, I already know it")
                    .foregroundColor(.gray)
            }
            Button(role: .cancel){
                showGuidence.toggle()
            }label:{
                Text("OK, let go")
            }
        }
        .statusBar(hidden: true)
        .onAppear() {
            withAnimation(Animation.easeInOut){
                httpManager.statusLoc = 0
                coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel)
            }
            // TODO: localization Button
        }
        .halfSheet(showSheet: $placementSetting.openModelList){
            ModelPickerView()
                .environmentObject(placementSetting)
                .environmentObject(usdzManagerViewModel)
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(goBack: .constant(false))
            .environmentObject(UserViewModel())
            .environmentObject(ARViewModel())
            .environmentObject(HttpAuth())
            .environmentObject(CoachingViewModel())
            .environmentObject(PlacementSetting())
            .environmentObject(SceneManagerViewModel())
            .environmentObject(ModelDeletionManagerViewModel())
            .environmentObject(MessageViewModel())
    }
}

