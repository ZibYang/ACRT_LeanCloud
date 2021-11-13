//
//  ModelDeletionManagerViewModel.swift
//  FocusEntityPlacer
//
//  Created by baochong on 2021/11/13.
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
