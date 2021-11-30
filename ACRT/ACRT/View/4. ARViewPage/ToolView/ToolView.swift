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

// [playSound] reference: https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
//             reference: https://www.hackingwithswift.com/forums/swiftui/playing-sound/4921
import SwiftUI
import AVFoundation

struct ToolView: View {
    @EnvironmentObject var persistenceHelperViewModel : PersistenceHelperViewModel
    @EnvironmentObject var placementSetting : PlacementSetting
    @EnvironmentObject var sceneManager : SceneManagerViewModel
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    @EnvironmentObject var httpManager: HttpAuth
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var modelDeletionManager : ModelDeletionManagerViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var messageModel : MessageViewModel

    @State var showBottomView = false
    @State var audioPlayer: AVAudioPlayer!
    @State var showPersistenceSignInAlert = false
    @State var showPersistenceLocalizeAlert = false
    
    @Binding var showCameraButton: Bool
    @Binding var snapShot: Bool
    @Binding var showMesh: Bool
    @Binding var showOcclusion: Bool
    @Binding var goBack: Bool
    @Binding var showGuidence: Bool
    
    @State private var snapshotBackgroundOpacity = 0.0
    
    @State var showHint = false
    @State var hintBackground = Color.clear
    @State var hintMessage = ""
    @State var showHintTimeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .opacity(snapshotBackgroundOpacity)
            
            topToolGroup
            
            leftToolGroup
            
            rightToolGroup
            
            snapShotButton

            if modelDeletionManager.entitySelectedForDeletion == nil {
                placeModelView
            } else {
                VStack{
                    Spacer()
                    DeletionView()
                        .environmentObject(sceneManager)
                        .environmentObject(modelDeletionManager)
                        .padding()
                }
            }
            if showGuidence{
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                UseToolGuidenceView(showGuidence: $showGuidence)
            }
        }
    }
    
    var placeModelView: some View{
        VStack{
            Spacer()
            ModelSelectedView()
                .environmentObject(placementSetting)
                .padding(.horizontal)
        }
        .offset(y: placementSetting.isInCreationMode && !showCameraButton ? 0 : 300)
        .offset(y: messageModel.isMessaging ? 300 : 0)
    }
    
    var topToolGroup: some View{
        VStack {
            // MARK: Top tool
            HStack {
                // MARK: Quit Button
                Button(action: {
                    impactLight.impactOccurred()
                    withAnimation(Animation.easeInOut(duration: 0.8)){
                        goBack = false // refer to everythingSetted
                    }
                    sceneManager.ClearWholeAnchors()
                    httpManager.statusLoc = 0
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(false, forKey: "SkipPrepareView")
                }, label:{
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                })
                    .padding(.all, 6)
                    .background(Material.ultraThinMaterial)
                    .cornerRadius(10)
                    
                TopToolView(showMesh: $showMesh, showCamera: $showCameraButton, showOcclusion: $showOcclusion, showHint: $showHint, hintMessage: $hintMessage, hintBackground: $hintBackground, showHintTimeRemaining:$showHintTimeRemaining)
                    .padding(.horizontal, 6)
                    .padding(.all, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .environmentObject(sceneManager)
                
                Spacer()
            }
//            .padding(.top, 10)
            .padding(.leading)
            .padding(.top)
            .offset(x: coachingViewModel.isCoaching ? -400 : 0)
            HStack {
                Text(LocalizedStringKey(hintMessage))
                    .font(.caption)
                    .foregroundColor(showHint ? .white : .clear)
                    .padding(5)
                    .padding(.horizontal, 5)
                    .background(showHint ? hintBackground : .clear)
                    .cornerRadius(10)
                Spacer()
            }
            .padding(.leading)
            .onReceive(timer) { time in
                if showHint{
                    if self.showHintTimeRemaining > 0 {
                        self.showHintTimeRemaining -= 1
                    }else{
                        withAnimation(Animation.easeInOut){
                            showHint = false
                        }
                    }
                }
            }
            .offset(x: coachingViewModel.isCoaching ? -400 : 0)
            Spacer()
        }
    }
    
    var leftToolGroup: some View{
        VStack{
            Spacer()
            // MARK: Left center tool
            HStack {
                LeftToolView(showCameraButton: $showCameraButton)
                    .padding(.all, 2)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .environmentObject(placementSetting)
                    .environmentObject(arViewModel)
                    .environmentObject(httpManager)
                    .environmentObject(coachingViewModel)
                Spacer()
            }
            .padding(.horizontal)
            HStack {
                relocationButton
                Spacer()
            }
            .padding(.horizontal)
            Spacer()
        }
        .offset(x: coachingViewModel.isCoaching ? -150 : 0)
        .offset(x: showCameraButton ? -150 : 0)
    }
    
    var relocationButton: some View{
        //MARK: relocation Button
        Button(action: {
            impactLight.impactOccurred()
            httpManager.statusLoc = 0
            placementSetting.isInCreationMode = false
            showCameraButton = false
            coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel)
        }, label:{
            Image(systemName: "location")
                .foregroundColor(.white)
                .frame(width: 34, height: 34)
        })
            .padding(.all, 5)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .contextMenu{
                Label("Locate again", systemImage: "location.circle.fill")
            }
    }
    
    var rightToolGroup: some View{
        VStack{
            Spacer()
            // MARK: Left center tool
            HStack {
                Spacer()
                VStack{
                    downloadButton
                    
                    uploadButton
                    
                    clearSceneButton
                }
            }
            .padding(.horizontal)
            .offset(x: coachingViewModel.isCoaching ? 150 : 0)
            .offset(x: placementSetting.isInCreationMode ? 0 : 150)
            .offset(x: showCameraButton ? 150 : 0)
            .offset(x: modelDeletionManager.entitySelectedForDeletion == nil ? 0 : 150)
            Spacer()
        }
        .alert("Please log in before uploading or downloading", isPresented: $showPersistenceSignInAlert) {
            Button(role: .none){
            }label:{
                Text("Don't log in now")
            }
            Button(role: .cancel){
                userViewModel.showUserPanel.toggle()
            }label:{
                Text("Log in now")
            }
        }
        .alert("Please localize before uploading or downloading", isPresented: $showPersistenceLocalizeAlert) {
            Button(role: .none){
            }label:{
                Text("Don't localize now")
            }
            Button(role: .cancel){
                httpManager.statusLoc = 0
                placementSetting.isInCreationMode = false
                coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel)
            }label:{
                Text("Localize now")
            }
        }
    }
    
    var clearSceneButton: some View{
        //MARK: clear Button
        Button(action: {
            impactLight.impactOccurred()
            self.sceneManager.ClearCreativeAnchors()
        }, label:{
            Image(systemName: "trash")
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        })
            .padding(.all, 6)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .contextMenu{
                Label("Clear all model you put", systemImage: "trash.circle.fill")
            }
            .alert(isPresented: $sceneManager.deleteHint){
                Alert(title: Text("Hint"), message: Text(LocalizedStringKey(sceneManager.deleteHintMessage)), dismissButton: .default(Text("OK")))
            }
    }
    
    var uploadButton: some View{
        // MARK: upload button
        Button(action: {
            impactLight.impactOccurred()
            if userViewModel.isSignedIn == false {
                showPersistenceSignInAlert.toggle()
            } else if arViewModel.hasBeenLocalized == false {
                showPersistenceLocalizeAlert.toggle()
            } else {
                sceneManager.shouldUploadSceneToCloud = true
            }
        }, label:{
            if !persistenceHelperViewModel.uploadIsDone{
                ProgressView()
                    .frame(width: 30, height: 30)
            }else{
                Image(systemName: "icloud.and.arrow.up")
                    .foregroundColor(userViewModel.isSignedIn == false || arViewModel.hasBeenLocalized == false ? .gray : .white)
                    .frame(width: 30, height: 30)
            }
        })
            .padding(.all, 6)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .contextMenu{
                Label("Upload objects", systemImage: "arrow.up.to.line.circle.fill")
            }
    }
    
    var downloadButton: some View{
        // MARK: download button
        Button(action: {
            impactLight.impactOccurred()
            if userViewModel.isSignedIn == false {
                showPersistenceSignInAlert.toggle()
            } else if arViewModel.hasBeenLocalized == false {
                showPersistenceLocalizeAlert.toggle()
            } else {
                sceneManager.shouldDownloadSceneFromCloud = true
            }
        }, label:{
            if !persistenceHelperViewModel.downloadIsDone{
                ProgressView()
                    .frame(width: 30, height: 30)
            }else{
                Image(systemName: "icloud.and.arrow.down")
                    .foregroundColor(userViewModel.isSignedIn == false || arViewModel.hasBeenLocalized == false ? .gray : .white)
                    .frame(width: 30, height: 30)
            }
        })
            .padding(.all, 6)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .contextMenu{
                Label("Downloads objects", systemImage: "arrow.down.to.line.circle.fill")
            }

    }
    
    var snapShotButton: some View{
        VStack{
            Spacer()
            // MARK: SnapShot button
            Button(action: {
                impactMedium.impactOccurred()
                guard let shutterPath = Bundle.main.url(forResource: "ARKitInteraction_shutter.mp3", withExtension: nil) else{
                    fatalError("Unable to find ARKitInteraction_shutter.mp3 in bundle")
                }
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: shutterPath)
                    audioPlayer.play()
                }catch{
                    print(error.localizedDescription)
                }
                snapshotBackgroundOpacity = 1.0
                withAnimation(Animation.easeInOut(duration: 1.0)){
                    snapshotBackgroundOpacity = 0.0
                }
                withAnimation(Animation.easeInOut(duration: 0.6)){
                    snapShot.toggle()
                }
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

struct ToolView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ToolView(showCameraButton: .constant(false), snapShot: .constant(false),showMesh: .constant(false), showOcclusion: .constant(true), goBack: .constant(false), showGuidence: .constant(false))
                
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 10, endRadius: 300)
                    .ignoresSafeArea()
                ToolView(showCameraButton: .constant(false), snapShot: .constant(false),showMesh: .constant(false), showOcclusion: .constant(true), goBack: .constant(false), showGuidence:  .constant(false))
            }
            .previewInterfaceOrientation(.landscapeLeft)
            
            ToolView(showCameraButton: .constant(false) ,snapShot: .constant(false),showMesh: .constant(false), showOcclusion: .constant(true),goBack: .constant(false), showGuidence: .constant(false))

                .preferredColorScheme(.dark)
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
        .environmentObject(PlacementSetting())
        .environmentObject(SceneManagerViewModel())
        .environmentObject(CoachingViewModel())
        .environmentObject(HttpAuth())
        .environmentObject(ARViewModel())
        .environmentObject(ModelDeletionManagerViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(PersistenceHelperViewModel())
        .environmentObject(MessageViewModel())
    }
}
