//
//  HttpAuth.swift
//  RKDSLAM_new
//
//  Created by baochong on 2021/10/17.
//

import Foundation
import Combine
import RealityKit
import UIKit
import VideoToolbox




extension UIImage {
    func pixelData() -> [UInt8]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        return pixelData
    }
 }


struct ServerMessage : Decodable {
    let q: [Float]
    let t: [Float]
    let rmatrix: [[Float]]
}

struct SensetimeServerMessage : Decodable {
    let pose : [Float]
    let x: Double
    let y: Double
    let z: Double
    let status : String
}

class HttpAuth : ObservableObject {
    var didChange = PassthroughSubject<HttpAuth, Never>()
    
    @Published var statusLoc : Int = 0
    
    var T_ci_w : simd_float4x4!
    let qiuShiUrl: String = "http://arctbch.nat300.top/loc1"
    let inTimeUrl : String = "http://42wwtz.natappfree.cc/loc1"
    let qiuShiUrlSensetime: String = "https://inception.sensetime.com/api/positioning/v1/sites/hz-lab/floors/jiangtang"
    
    func queryOnline(url: String, strBase64 : String, width: Int, height:Int, intrinsic: simd_float3x3, isGrayScale: Bool, useRawData: Bool,extrinsic: simd_float4x4) {
        
        guard let body = makeBody(strBase64: strBase64 ,width:width, height: height, intrinsic: intrinsic, isGrayScale: isGrayScale, useRawData:useRawData, extrinsic: extrinsic) else {
            return }
        guard let request = makeRequest(url: url, body: body) else {
            return
        }
        
        requestAndCallback(request: request)
    }
    
    func makeBody(strBase64 : String, width: Int, height:Int,  intrinsic: simd_float3x3, isGrayScale: Bool, useRawData: Bool, extrinsic: simd_float4x4) -> [String:Any]? {
        
        let body:[String:Any] = ["is_grayscale": isGrayScale,
                    "image":strBase64,
                    "intrinsic": ["model":"OPENCV",
                                  "width": width,
                                  "height": height,
                                  "params": [intrinsic.columns.0[0], intrinsic.columns.1[1], intrinsic.columns.2[0], intrinsic.columns.2[1],
                                             0.0, 0.0, 0.0, 0.0]
                                 ],
                     "extrinsic": [[extrinsic.columns.0[0], extrinsic.columns.1[0], extrinsic.columns.2[0], extrinsic.columns.3[0]],
                                  [extrinsic.columns.0[1], extrinsic.columns.1[1], extrinsic.columns.2[1], extrinsic.columns.3[1]],
                                  [extrinsic.columns.0[2], extrinsic.columns.1[2], extrinsic.columns.2[2], extrinsic.columns.3[2]],
                                  [extrinsic.columns.0[3], extrinsic.columns.1[3], extrinsic.columns.2[3], extrinsic.columns.3[3]]],
                     "useRawData": useRawData]
        return body
    }

    func makeRequest(url : String , body: [String:Any]) -> URLRequest?{
        
        guard let url = URL(string: url) else {
            return nil
        }

        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func requestAndCallback(request : URLRequest) {
        DispatchQueue.main.async {
            self.statusLoc = -1
        }
        
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
                if self.statusLoc != 1 {
                    self.statusLoc = 1
                    self.T_ci_w = Tcw
                }
            }
        }.resume()
    }
    
    func querySensetimeOnline(url: String, strBase64 : String, width: Int, height: Int,intrinsic: simd_float3x3) {
        
        guard let body = makeSensetimeBody(strBase64: strBase64 , width: width, height: height, intrinsic: intrinsic) else{
            return
        }
        guard let request = makeRequest(url: url, body: body) else {
            return
        }
        requestAndSensetimeCallback(request: request)
    }
    
    func makeSensetimeBody(strBase64 : String, width: Int, height:Int, intrinsic: simd_float3x3) -> [String:Any]? {

        
        let body:[String:Any] = ["image":strBase64,
                    "cameraConfig": [
                                  "width": width,
                                  "height": height,
                                  "fx": intrinsic.columns.0[0],
                                  "fy": intrinsic.columns.1[1],
                                  "cx": intrinsic.columns.2[0],
                                  "cy": intrinsic.columns.2[1],
                                 ]
                    ]
        return body
    }
    
    func requestAndSensetimeCallback(request : URLRequest) {
        DispatchQueue.main.async {
        self.statusLoc = -1
        }
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
            let finalData = try! JSONDecoder().decode(SensetimeServerMessage.self, from: data)
            if finalData.status != "SUCCESS" {
                print("Warning : BCH: localization failed because status is " , finalData.status)
                DispatchQueue.main.async {
                    self.statusLoc = 0
                }
                return
            }
            print("DEBUG(BCH): status " , finalData.status)

            print("DEBUG(BCH): pos: " , finalData.x, finalData.y, finalData.z)
            print("DEBUG(BCH): pose " , finalData.pose)

            let Tcw : simd_float4x4 = simd_float4x4(
                simd_float4(finalData.pose[0], finalData.pose[1], finalData.pose[2], finalData.pose[3]),
                simd_float4(finalData.pose[4], finalData.pose[5], finalData.pose[6], finalData.pose[7]),
                simd_float4(finalData.pose[8], finalData.pose[9], finalData.pose[10], finalData.pose[11]),
                simd_float4(0,0,0,1.0)).transpose
            
            print("DEBUG(BCH): Tcw " , (Tcw).transpose)

            DispatchQueue.main.async {
                if self.statusLoc != 1 {
                    self.statusLoc = 1
                    self.T_ci_w = Tcw
                }
            }
        }.resume()
    }
}
