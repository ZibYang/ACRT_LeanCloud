//
//  CustomARView.swift
//  FocusEntityPlacer
//
//  Created by baochong on 2021/11/5.
//

import RealityKit
import Foundation
import FocusEntity
import ARKit

class CustomARView: ARView {
    
    var foucsEntity : FocusEntity?
    var modelDeletionManager : ModelDeletionManagerViewModel?

    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init(frame frameRect: CGRect, modelDeletionManager : ModelDeletionManagerViewModel?) {
        self.modelDeletionManager = modelDeletionManager

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
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(recognizer : UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)
        if let entity = self.entity(at: location) as? ModelEntity, let deletionManager = self.modelDeletionManager {
            deletionManager.entitySelectedForDeletion = entity
        }
    }
}
