//
//  ImageUtils.swift
//  FirstARKitDemo
//
//  Created by baochong on 2021/10/27.
//

import Foundation
import SwiftUI
import RealityKit
import VideoToolbox

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

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

func convertCapturedImageToUIImage(pixelBuffer: CVPixelBuffer, transform : CGAffineTransform?) ->UIImage? {
    
    var cgImage: CGImage?
    VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

    guard let cgImage = cgImage else {
        return nil
    }

    if transform != nil {
        let ciImage = CIImage(cgImage: cgImage)
        let finalCIImage = ciImage.transformed(by: transform!)
        print("DEBUG(BCH): transform image")
        return UIImage(ciImage: finalCIImage)
    } else {
        return UIImage(cgImage: cgImage)
    }
//        if transform != nil {
//
//        } else {
//
//        }
//        return UIImage(ciImage: CIImage(cvImageBuffer: pixelBuffer))

}

func rotateImage(image : UIImage, intrinsic: simd_float3x3) ->(image: UIImage, intrinsic: simd_float3x3)? {
    guard let rotated_image = image.rotate(radians: Float.pi / 2) else { return nil }
    let rotated_intrinsic = simd_float3x3(simd_float3(intrinsic.columns.1[1], 0, intrinsic.columns.2[1]),
                                          simd_float3(0, intrinsic.columns.0[0], intrinsic.columns.2[0]),
                                          simd_float3(0, 0, 1)).transpose
    return (rotated_image, rotated_intrinsic)
    
}

//func processImage( image: UIImage, isGrayscale: Bool)->UIImage? {
//    var resultImage : UIImage = image
//    if isGrayscale == true {
//        guard let grey_rotated_image :UIImage = convertImageToGrayScale(image : image) else {
//            print("Warning: conversion to grey scale failed")
//            return nil
//        }
//        resultImage = grey_rotated_image
//    }
//    return resultImage
//}

func processImage( image: UIImage, isGrayscale: Bool, useRawData: Bool)->String? {
    var strBase64 : String?
    if (isGrayscale == true && useRawData == true) {
        guard let data = convert2GRAYImage(image_: image) else {
            return nil
        }
        strBase64 = data.base64EncodedString()
    } else if(isGrayscale == true && useRawData == false) {
        guard let grey_rotated_image :UIImage = convertImageToGrayScale(image: image) else {
                    print("Warning: conversion to grey scale fails")
                    return nil
        }
        guard let data = grey_rotated_image.jpegData(compressionQuality: 1.0) else {
            print("Warning: conversion from uiimage to data fails")
            return nil
        }
        strBase64 = data.base64EncodedString()
    }
    else if(isGrayscale == false && useRawData == false){
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        strBase64 = data.base64EncodedString()
    } else {
        return nil
    }
    return strBase64

}

//reference: https://gist.github.com/vlondon/3a3c7552c83550f229dd
func convertImageToGrayScale(image: UIImage) -> UIImage? {
    // Create image rectangle with current image width/height
    let imageRect: CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)
    // Grayscale color space
    let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
    
    // Create bitmap content with current image size and grayscale colorspace
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
    guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
    
    // Draw image into current context, with specified rectangle using previously defined context (with grayscale colorspace)
    guard let cgiImage = image.cgImage else {return  nil}
    
    context.draw(cgiImage, in: imageRect)
    
    // Create bitmap image info from pixel data in current context
    guard let imageRef: CGImage = context.makeImage() else { return nil }
    
    // Create a new UIImage object
    let newImage: UIImage = UIImage(cgImage: imageRef)
    
    // Return the new grayscale image
    return newImage
}

func encodeImage( image: UIImage) ->String?{

    //Now use image to create into NSData format
    guard let imageData = image.jpegData(compressionQuality: 1) else {
        return nil
    }
    
    let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
    return strBase64
}

func encodeImageSensetime( image: UIImage) ->String?{
    
    //Now use image to create into NSData format
    guard let imageArrayData = image.pixelData()  else {
        return nil
    }
    let imageData = NSData(bytes: imageArrayData, length: imageArrayData.count)

    let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
    //options: NSData.Base64EncodingOptions.endLineWithLineFeed
//        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
    print("DEBUG(BCH): decode image by base64")

    return strBase64
}


func pixelBufferToUIImage(pixelBuffer : CVPixelBuffer ) -> UIImage?
{
    let ciImage :CIImage = CIImage(cvPixelBuffer:pixelBuffer)
    
    let temporaryContext: CIContext = CIContext(options: nil)
    guard let videoImage:CGImage = temporaryContext.createCGImage(ciImage, from: CGRect(x: 0, y:0,width: CGFloat(CVPixelBufferGetWidth(pixelBuffer)),height:CGFloat(CVPixelBufferGetHeight(pixelBuffer)))) else {
        return nil
    }
    let uiImage : UIImage = UIImage(cgImage: videoImage)
    
    return uiImage;
}

func convert2GRAYImage(image_ : UIImage) -> NSData?
{

    guard let image : CGImage = image_.cgImage else {
        return nil
    }
    var context : CGContext?
    var colorSpace : CGColorSpace?
    var rawData : UnsafeMutableRawPointer?


    let bitsPerPixel: size_t = 8
    let bitsPerComponent : size_t = 8;
    let bytesPerPixel : size_t = bitsPerPixel/bitsPerComponent;


    let width : size_t = image.width
    let height : size_t = image.height

    let bytesPerRow : size_t = width * bytesPerPixel
    let bufferLength : size_t = bytesPerRow * height;

    colorSpace = CGColorSpaceCreateDeviceGray();

    guard let colorSpace = colorSpace else {
        return nil
    }
    
//    rawData = [UInt8](repeating: 0, count: bufferLength)
    rawData = UnsafeMutableRawPointer( calloc(bufferLength, MemoryLayout<UInt8>.size) )


    guard let rawData = rawData else {
            return nil
    }
    let bitmapInfo : CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

    context = CGContext(data:rawData, width: width,height:height,bitsPerComponent: bitsPerComponent,bytesPerRow:bytesPerRow,space:colorSpace,bitmapInfo:bitmapInfo.rawValue)
    guard let context = context else {
        return nil
    }

    let rect : CGRect = CGRect(x: 0, y: 0, width: width, height:height)
    context.draw(image, in: rect)
    let bitmapData = NSData(bytes: rawData, length: bufferLength)
    free(rawData)
    return bitmapData
//    return newImage

}
