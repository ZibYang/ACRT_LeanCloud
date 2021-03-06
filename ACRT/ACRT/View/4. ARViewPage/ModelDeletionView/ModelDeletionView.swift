//
//  DeletionView.swift
//  FocusEntityPlacer
//
//  Created by baochong on 2021/11/13.
//

import SwiftUI

struct DeletionView : View {
    @EnvironmentObject var sceneManager : SceneManagerViewModel
    @EnvironmentObject var modelDeletionManager : ModelDeletionManagerViewModel
    var body: some View {
        HStack {
            Spacer()
            DeletionButton(systemIconName: "xmark.circle.fill") {
                print("Cancel Deletion button pressed")
                modelDeletionManager.entitySelectedForDeletion = nil
            }
            Spacer()
            DeletionButton(systemIconName: "trash.circle.fill") {
                print("Confirmed Deletion button pressed")
                
                guard let anchor = self.modelDeletionManager.entitySelectedForDeletion?.anchor else {return}
                
                let anchoringIdentifier = anchor.anchorIdentifier
                
                if let index = self.sceneManager.anchorEntities.firstIndex(where: {$0.anchorIdentifier == anchoringIdentifier}) {
                    print("Deleting anchorEntity with id \(String(describing: anchoringIdentifier))")
                    self.sceneManager.anchorEntities.remove(at: index)
                }
                anchor.removeFromParent()
                self.modelDeletionManager.entitySelectedForDeletion = nil
            }
            Spacer()
        }.padding(.bottom, 30)
    }
}

struct DeletionButton: View {
    let systemIconName: String
    let action : () -> Void
    
    var body : some View {
        Button(action: {
            self.action()
        }) {
            Image(systemName: systemIconName)
                .font(.system(size:50, weight: .light, design: .default))
                .foregroundColor(systemIconName == "trash.circle.fill" ? .red : .white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 85, height: 85)
    }
}
