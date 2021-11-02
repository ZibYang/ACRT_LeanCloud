//
//  USDZModel.swift
//  FirstARKitDemo
//
//  Created by baochong on 2021/10/21.
//
import UIKit
import Foundation
import RealityKit
import Combine

class USDZModel1{
    var modelName: String
    var modelEntity: ModelEntity?
    private var cancellable: AnyCancellable? = nil
    
    
    init(modelName: String){
        self.modelName = modelName
        let fileName = self.modelName+".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion : {loadCompletion in
                print("1")
            }, receiveValue:{modelEntity in
                self.modelEntity = modelEntity
            })
    }
}
