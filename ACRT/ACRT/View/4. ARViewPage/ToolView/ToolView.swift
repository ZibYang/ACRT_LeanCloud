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
    @EnvironmentObject var placementSetting : PlacementSetting
    @EnvironmentObject var sceneManager : SceneManagerViewModel
    @EnvironmentObject var coachingViewModel : CoachingViewModel
    @EnvironmentObject var httpManager: HttpAuth
    @EnvironmentObject var arViewModel: ARViewModel
    @EnvironmentObject var modelDeletionManager : ModelDeletionManagerViewModel
    @EnvironmentObject var userViewModel : UserViewModel


    @State var showBottomView = false
    @State var showCameraButton = false
    @State var audioPlayer: AVAudioPlayer!
    @State var showPersistenceAlert = false
    @State var persistenceInfo = ""

    
    @Binding var snapShot: Bool
    @Binding var showMesh: Bool
    @Binding var goBack: Bool
    
    @State private var snapshotBackgroundOpacity = 0.0
    
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
    }
    
    var topToolGroup: some View{
        VStack {
            // MARK: Top tool
            HStack {
                // quit Button
                Button(action: {
                    withAnimation(Animation.easeInOut(duration: 0.8)){
                        goBack.toggle()
                    }
                    sceneManager.ClearWholeAnchors()
                    httpManager.statusLoc = 0
                    print("pressed")
                }, label:{
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                })
                    .padding(.all, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    
                TopToolView(showMesh: $showMesh, showCamera: $showCameraButton)
                    .padding(.all, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .environmentObject(sceneManager)
                
                Spacer()
            }
//            .padding(.top, 10)
            .padding()
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
                    .padding(.all, 5)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
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
    }
    
    
    var relocationButton: some View{
        //MARK: relocation Button
        Button(action: {
            httpManager.statusLoc = 0
            placementSetting.isInCreationMode = false
            coachingViewModel.comeFromPrepareView = false
            showCameraButton = false
            coachingViewModel.StartLocalizationAndModelLoadingAsync(httpManager: httpManager, arViewModel: arViewModel)
        }, label:{
            Image(systemName: "location")
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
        })
            .padding(.all, 6)
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
                .padding(.all, 6)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .offset(x: coachingViewModel.isCoaching ? 150 : 0)
            .offset(x: placementSetting.isInCreationMode ? 0 : 150)
            Spacer()
            

        }
    }
    
    var clearSceneButton: some View{
        //MARK: clear Button
        Button(action: {
            self.sceneManager.ClearCreativeAnchors()
            
        }, label:{
            Image(systemName: "trash")
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
        })
            .contextMenu{
                Label("Clear all model you put", systemImage: "trash.circle.fill")
            }
    }
    var uploadButton: some View{
        // MARK: upload button
        Button(action: {
            if userViewModel.isSignedIn == false {
                showPersistenceAlert = true
                persistenceInfo = "Please log in before uploading or downloading"
            } else if arViewModel.hasBeenLocalized == false {
                showPersistenceAlert = true
                persistenceInfo = "Please localize before uploading or downloading"
            } else {
                showPersistenceAlert = false
                sceneManager.shouldUploadSceneToCloud = true
            }
        }, label:{
            Image(systemName: "icloud.and.arrow.up")
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
        })
            .contextMenu{
                Label("Upload objects", systemImage: "arrow.up.to.line.circle.fill")
            }
            .alert(isPresented: $showPersistenceAlert) {
                Alert(title: Text("Hint"), message: Text(persistenceInfo), dismissButton: .default(Text("OK")))
            }
        
    }
    
    var downloadButton: some View{
        // MARK: download button
        Button(action: {
            if userViewModel.isSignedIn == false {
                showPersistenceAlert = true
                persistenceInfo = "Please log in before uploading or downloading"
            } else if arViewModel.hasBeenLocalized == false {
                showPersistenceAlert = true
                persistenceInfo = "Please localize before uploading or downloading"
            } else {
                showPersistenceAlert = false
                sceneManager.shouldDownloadSceneFromCloud = true
            }
        }, label:{
            Image(systemName: "icloud.and.arrow.down")
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
        })
            .contextMenu{
                Label("Downloads objects", systemImage: "arrow.down.to.line.circle.fill")
            }
            .alert(isPresented: $showPersistenceAlert) {
                Alert(title: Text("Hint"), message: Text(persistenceInfo), dismissButton: .default(Text("OK")))
            }
    }
    
    var snapShotButton: some View{
        VStack{
            Spacer()
            // MARK: SnapShot button
            Button(action: {
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
                withAnimation(Animation.easeInOut(duration: 0.8)){
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
            ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false))
                .environmentObject(PlacementSetting())
                .environmentObject(SceneManagerViewModel())
                .environmentObject(CoachingViewModel())
                .environmentObject(HttpAuth())
                .environmentObject(ARViewModel())
                .environmentObject(USDZManagerViewModel())
                .environmentObject(ModelDeletionManagerViewModel())
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 10, endRadius: 300)
                    .ignoresSafeArea()
                ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false))
                    .environmentObject(PlacementSetting())
                    .environmentObject(SceneManagerViewModel())
                    .environmentObject(CoachingViewModel())
                    .environmentObject(HttpAuth())
                    .environmentObject(ARViewModel())
                    .environmentObject(USDZManagerViewModel())
                    .environmentObject(ModelDeletionManagerViewModel())
            }
            .previewInterfaceOrientation(.landscapeLeft)
            
            ToolView(snapShot: .constant(false),showMesh: .constant(false), goBack: .constant(false))
                .environmentObject(PlacementSetting())
                .environmentObject(SceneManagerViewModel())
                .environmentObject(CoachingViewModel())
                .environmentObject(HttpAuth())
                .environmentObject(ARViewModel())
                .environmentObject(USDZManagerViewModel())
                .environmentObject(ModelDeletionManagerViewModel())
                .preferredColorScheme(.dark)
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}
