//
//  CustomARView.swift
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

import RealityKit
import Foundation
import FocusEntity
import ARKit

class CustomARView: ARView {
    
    var foucsEntity : FocusEntity?
    var modelDeletionManager : ModelDeletionManagerViewModel?
    
    var all_message:String = ""
    var is_loading: Bool = false
    var messageModel: MessageViewModel?

    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init(frame frameRect: CGRect, modelDeletionManager : ModelDeletionManagerViewModel?, messageModel: MessageViewModel?) {
        self.modelDeletionManager = modelDeletionManager
        self.messageModel = messageModel

        super.init(frame: frameRect)
        self.foucsEntity = FocusEntity(on: self, focus: .classic)
        self.configure()
        self.enableObjectDeletion()
    }
    
    @MainActor @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal, .vertical]
//        session.run(config)
    }
    
}

extension CustomARView {
    func enableObjectDeletion() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    
        self.addGestureRecognizer(longPressGesture)
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleLongPress(recognizer : UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)
        if let entity = self.entity(at: location) as? ModelEntity, let deletionManager = self.modelDeletionManager, let anchor = entity.anchor {
            if AnchorIdentifierHelper.decode(identifier: anchor.name)[0] != rootUserName {
                print("select \(entity.name)")
                deletionManager.entitySelectedForDeletion = entity
            } else {
                print("select nil")
            }
        }
    }
    
    @objc func handleTap(recognizer : UITapGestureRecognizer) {
        let location = recognizer.location(in: self)
        if let entity = self.entity(at: location) as? ModelEntity, let deletionManager = self.modelDeletionManager, let anchor = entity.anchor {
            print("[tap] \(anchor.name)")
            if AnchorIdentifierHelper.decode(identifier: anchor.name)[1] == "user_text_MessageBoard.reality" {
                messageModel?.isMessaging = true
            }
        }
    }
}
