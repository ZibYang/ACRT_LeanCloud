//
//  SceneManagerViewModel.swift
//  ACRT
//
//  Created by baochong on 2021/11/12.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation
import RealityKit

class SceneManagerViewModel: ObservableObject {
    var shouldUploadSceneToCloud: Bool = false
    var shouldDownloadSceneFromCloud: Bool = false
    @Published var anchorEntities: [AnchorEntity] = []

    
    lazy var persistenceUrl: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create : true).appendingPathComponent("arf.persistence")
        } catch {
            fatalError("Unable to get persistenceUrl \(error.localizedDescription)")
        }
    }()
}
