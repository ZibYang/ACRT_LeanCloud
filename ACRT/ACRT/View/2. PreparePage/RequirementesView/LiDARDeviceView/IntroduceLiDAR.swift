//
//  IntroduceLiDAR.swift
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
//


// [LoopVideo] reference: https://github.com/SchwiftyUI/LoopingPlayer/blob/master/LoopingPlayer/LoopingPlayer.swift

import SwiftUI
import AVFoundation

struct IntroduceLiDARView: View{
    @Environment(\.dismiss) var dismissSheet
    
    var body: some View{
        ZStack {
            IntroduceLiDARBackground()
                .ignoresSafeArea()
                .blur(radius: 0.5)
            VStack(alignment: .leading, spacing: 50) {
                Text("LiDAR Scaner")
                    .font(.title)
                    .bold()
                Text("The LiDAR Scanner works with the pro cameras, motion sensors, and frameworks in iPhone 12 Pro, iPhone 13 Pro and iPad Pro to measure depth. This combination of hardware, software, and unprecedented innovation lets Apple provide the world’s best device for augmented reality.")
            }
            .foregroundColor(.white)
            .padding()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Understand") {
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                        dismissSheet()
                    }
                    .padding(.trailing)
                }
                Spacer()
            }
            .padding()
        }
        
    }
}

struct IntroduceLiDARView_Previews: PreviewProvider {
    static var previews: some View {
        IntroduceLiDARView()
    }
}

struct IntroduceLiDARBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return QueuePlayerUIView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing here
    }
}

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Load Video
        let fileUrl = Bundle.main.url(forResource: "IntroduceLiDAR", withExtension: "mov")!
        let playerItem = AVPlayerItem(url: fileUrl)
        
        // Setup Player
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        // Loop
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        // Play
        player.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
