//
//  ModelDeletionManagerViewModel.swift
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

import SwiftUI
import RealityKit

class ModelDeletionManagerViewModel : ObservableObject {
    @Published var entitySelectedForDeletion : ModelEntity? = nil {
        willSet(newValue) {
            if self.entitySelectedForDeletion == nil, let newlySelectedModelEntity = newValue {
                print("Selecting new entitySelectedFor Deletion, no prior selection.")
                
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if let previouslySelectedModelEntity = self.entitySelectedForDeletion, let newlySelectedModelEntity = newValue {
                print("Selecting new entitySelectedFor Deletion, had prior selection.")
                
                previouslySelectedModelEntity.modelDebugOptions = nil
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component

            } else if newValue == nil {
                print("Clearing entitySelectedForDelection.")

                self.entitySelectedForDeletion?.modelDebugOptions = nil

            }
        }
        
    }
    
    
}
