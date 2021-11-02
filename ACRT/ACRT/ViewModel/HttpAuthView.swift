//
//  HttpAuth.swift
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

import Foundation
import Combine
import RealityKit
import UIKit
import VideoToolbox


extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        guard let cgImage = cgImage else {
            return nil
        }

        self.init(cgImage: cgImage)
    }
}


struct ServerMessage : Decodable {
    let q: [Float]
    let t: [Float]
    let rmatrix: [[Float]]
}


class HttpAuth : ObservableObject {
    @Published var statusLoc : Int = -2
    
    var T_ci_w : simd_float4x4!
    let url: String = "http://10.78.92.86:3000/loc1"
    
    
    func queryOffline() {
        self.statusLoc = -1
        guard let image = UIImage(named: "IMG_1193.jpeg") else {
            print("DEBUG(BCH): Error: can not read image IMG_1193.jpg")
            self.statusLoc = 0
            return
        }
        print("DEBUG(BCH): Info: read image IMG_1193.jpg")
        //Now use image to create into NSData format
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            self.statusLoc = 0
            return
        }
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)

        let body:[String:Any] = ["is_grayscale":false,
                    "image":strBase64,
                    "intrinsic": ["model":"OPENCV",
                                  "width": image.size.width,
                                  "height": image.size.height,
                                  "params": [975.316056, 975.316056, 580.000000, 592.500000, -0.006952,
                                             0.0, 0.0, 0.0]
                                 ]]
        requestLocalization(body: body)
    }
    
    func queryOnline(image: UIImage, intrinsic: simd_float3x3, extrinsic: simd_float4x4) {
        self.statusLoc = -1
        //Now use image to create into NSData format
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            self.statusLoc = 0
            return
        }
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)

        let body:[String:Any] = ["is_grayscale":false,
                    "image":strBase64,
                    "intrinsic": ["model":"OPENCV",
                                  "width": image.size.width,
                                  "height": image.size.height,
                                  "params": [intrinsic.columns.0[0], intrinsic.columns.1[1], intrinsic.columns.2[0], intrinsic.columns.2[1],
                                             0.0, 0.0, 0.0, 0.0]
                                 ],
                     "extrinsic": [[extrinsic.columns.0[0], extrinsic.columns.1[0], extrinsic.columns.2[0], extrinsic.columns.3[0]],
                                  [extrinsic.columns.0[1], extrinsic.columns.1[1], extrinsic.columns.2[1], extrinsic.columns.3[1]],
                                  [extrinsic.columns.0[2], extrinsic.columns.1[2], extrinsic.columns.2[2], extrinsic.columns.3[2]],
                                  [extrinsic.columns.0[3], extrinsic.columns.1[3], extrinsic.columns.2[3], extrinsic.columns.3[3]]]]
        requestLocalization(body: body)
    }

    
    func requestLocalization(body: [String:Any]) {
        
        guard let url = URL(string: url) else {
            self.statusLoc = 0
            return
        }

        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                print("DEBUG(BCHO): data is nil")
                DispatchQueue.main.async {
                    self.statusLoc = 0
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode != 200) {
                    print("DEBUG(BCHO): statusCode of httpResponse is ", httpResponse.statusCode)
                    DispatchQueue.main.async {
                        self.statusLoc = 0
                    }
                    return
                }
            }
            if error != nil{
                print("Error \(String(describing: error))")
                DispatchQueue.main.async {
                    self.statusLoc = 0
                }
                return
            }
                        
            print("DEBUG(BCH): data: ",data)
            print("DEBUG(BCH): response: ",response)
            print("DEBUG(BCH): error: ",error)
            let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
            var Tcw: simd_float4x4 = simd_float4x4()
            // assign as row-major way
            for i in 0..<3 {
                for j in 0..<3 {
                    Tcw[i][j] = finalData.rmatrix[i][j]
                }
                Tcw[i][3] = finalData.t[i]
            }
            Tcw[3][3] = 1.0
            // convert to col-major matrix which swift define
            Tcw = Tcw.transpose
            print("DEBUG(BCH): Loc Tcw",Tcw)
            DispatchQueue.main.async {
                self.statusLoc = 1
                self.T_ci_w = Tcw
            }
        }.resume()
    
    }
}
