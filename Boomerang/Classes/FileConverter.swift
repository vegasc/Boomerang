//
//  FileConverter.swift
//  Boomerang
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Aleksey Robul. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreGraphics

// https://github.com/caferrara/img-to-video/blob/master/img-to-video/ViewController.m
class FileConverter {
    /**
    Converts images array into mov file.
    When convertion complited it saves file at documents directory and returns url to the file.
    */
    static func convertImagesToMovie(name:String, images:[UIImage], size:CGSize, fps:UInt) -> URL? {
        // steps to convert
        // 1. Setup output path
        // 2. Setup AVAssetWriter
        // 3. Convert images to CGImage’s
        // 4. Finish AVAssetWriter session
        // 5. Export file with AVAssetExportSession
        
        // Setup output path
        guard let directory = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first else { return nil }
        let videoOutputPath = directory.appendingPathComponent(name)
        
        // remove file if it's already exists
        if FileManager.default.fileExists(atPath: videoOutputPath.path) {
            try? FileManager.default.removeItem(at: videoOutputPath)
        }
        
        // Setup AVAssetWriter
        var videoWriter:AVAssetWriter? = nil
        do {
            videoWriter = try AVAssetWriter(outputURL: videoOutputPath, fileType: .mov)
        } catch { return nil }
        
        let videoSettings: [String : Any] = [
            AVVideoCodecKey : AVVideoCodecType.h264,
            AVVideoWidthKey : size.width,
            AVVideoHeightKey : size.height
            ]
        
        let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput,
                                                           sourcePixelBufferAttributes: nil)
        
        assetWriterInput.expectsMediaDataInRealTime = true
        videoWriter?.add(assetWriterInput)
        videoWriter?.startWriting()
        videoWriter?.startSession(atSourceTime: kCMTimeZero)
        
        // Convert images to CGImage’s
        var buffer:CVPixelBuffer? = nil
        let frameCount:UInt = 0
        let frameDuration = fps * 6
        
        // if cgImage is nil frame will be ignored which leads to missing frames
        for img in images {
            guard img.cgImage != nil else { continue }
            buffer = pixelBufferFromCGImage(ref: img.cgImage!, size: size)
            
            var isAppend = false
            var j = 0
            while(!isAppend && j < 30) {
                guard adaptor.assetWriterInput.isReadyForMoreMediaData else { continue }
                let frameTime = CMTime(value: CMTimeValue(frameCount * frameDuration), timescale: CMTimeScale(fps))
                guard buffer != nil else { return nil }
                isAppend = adaptor.append(buffer!, withPresentationTime: frameTime)
                j += 1
            }
        }
        
        // Finish AVAssetWriter session
        assetWriterInput.markAsFinished()
        videoWriter?.finishWriting {}
        
        return videoOutputPath
    }
    
    static func pixelBufferFromCGImage(ref:CGImage, size:CGSize) -> CVPixelBuffer? {
        let options = [
            kCVPixelBufferCGImageCompatibilityKey : true,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true
        ] as NSDictionary
        
        var buffer:CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(size.width),
                                         Int(size.height),
                                         kCVPixelFormatType_32ARGB,
                                         options as CFDictionary,
                                         &buffer)
        guard status == kCVReturnSuccess else { return nil }
        
        CVPixelBufferUnlockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0))
        let bufferData = CVPixelBufferGetBaseAddress(buffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: bufferData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        guard context != nil else { return nil }
        context!.concatenate(CGAffineTransform(rotationAngle: 0))
        context!.draw(ref, in: CGRect.init(x: 0, y: 0, width: ref.width, height: ref.height))
        
        CVPixelBufferUnlockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0))
        return buffer!
        
//        let context = CGBitmapContextCreate(bufferData,
//                                             Int(size.width),
//                                             Int(size.height),
//                                             8,
//                                             4 * Int(size.width),
//                                             rgbColorSpace,
//                                             <#T##bitmapInfo: UInt32##UInt32#>)
    }
}































