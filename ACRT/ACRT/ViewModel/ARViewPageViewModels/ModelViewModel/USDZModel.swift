//
//  USDZModel.swift
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

import UIKit
import Foundation
import RealityKit
import Combine

class USDZModel{
    var modelName: String
    var type: String
    var modelEntity: Entity?
    var modelPreviewImage: UIImage?
    
    private var cancellable: AnyCancellable? = nil
    
    
    init(modelName: String){
        self.modelName = modelName
        self.type = modelName.components(separatedBy: ".")[1]
        //self.modelPreviewImage = UIImage(named: "sheet_"+modelName)
//        let fileName = self.modelName+".usdz"
//
//        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
//            .sink(receiveCompletion : {loadCompletion in
//            }, receiveValue:{ modelEntity in
//                self.modelEntity = modelEntity
//            })
    }
    
    func getBodyOfModelName() -> String {
        return self.modelName.components(separatedBy: ".")[0]
    }
    
    func createRealityURL(filename: String,
                          fileExtension: String,
                          sceneName:String) -> URL? {
        // Create a URL that points to the specified Reality file.
        guard let realityFileURL = Bundle.main.url(forResource: filename,
                                                   withExtension: fileExtension) else {
            print("Error finding Reality file \(filename).\(fileExtension)")
            return nil
        }

        // Append the scene name to the URL to point to
        // a single scene within the file.
        let realityFileSceneURL = realityFileURL.appendingPathComponent(sceneName,
                                                                        isDirectory: false)
        return realityFileSceneURL
    }
    
    func asyncLoadEntity(handler : @escaping(_ completed : Bool, _ error: Error?)->Void) {
        guard let url = createRealityURL(filename: self.modelName.components(separatedBy: ".")[0], fileExtension: self.type, sceneName: "") else {
            print("Warnning: can not create url \(self.modelName)")
            return
        }
        if self.type == "usdz" {
            self.cancellable = Entity.loadModelAsync(contentsOf: url)
                .sink(receiveCompletion : {loadCompletion in
                    if case let .failure(error) = loadCompletion {
                        print("Error: can not load \(url.description)")
                        handler(false,error)
                    }
                }, receiveValue:{modelEntity in
                    
                    handler(true,nil)
                    self.modelEntity = modelEntity
                })
        } else {
            self.cancellable = Entity.loadAsync(contentsOf: url)
                .sink(receiveCompletion : {loadCompletion in
                    if case let .failure(error) = loadCompletion {
                        print("Error: can not load \(url.description)")
                        handler(false,error)
                    }
                }, receiveValue:{modelEntity in
                    
                    handler(true,nil)
                    self.modelEntity = modelEntity
                })
        }
        
    }
}
