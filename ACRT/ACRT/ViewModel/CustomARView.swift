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
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        foucsEntity = FocusEntity(on: self, focus: .classic)
        configure()
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
