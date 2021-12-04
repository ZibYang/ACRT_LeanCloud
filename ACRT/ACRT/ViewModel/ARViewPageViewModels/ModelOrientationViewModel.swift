//
//  ModelOrientationViewModel.swift
//  ACRT
//
//  Created by baochong on 2021/12/4.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation

class ModelOrientationViewModel : ObservableObject {
    @Published var rotateRadianAroundX: Int = 0

    func toggleOrientation(isVerticalToGroundPrev: Bool) {
        if isVerticalToGroundPrev {
            if rotateRadianAroundX != 0 {
                rotateRadianAroundX = 0
            } else {
                rotateRadianAroundX = -90
            }
        } else {
            if rotateRadianAroundX != 0 {
                rotateRadianAroundX = 0
            } else {
                rotateRadianAroundX = 90
            }
        }
    }
    
    func IsVerticalToGroundCurrently(isVerticalToGroundPrev: Bool) -> Bool {
        return ( isVerticalToGroundPrev && rotateRadianAroundX == 0) || (isVerticalToGroundPrev == false && rotateRadianAroundX != 0) 
    }
    
    func resetStatus() {
        rotateRadianAroundX = 0
    }
    
    
}
