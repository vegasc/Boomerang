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
    static func convertImagesToMovie(name:String,
                                     images:[UIImage],
                                     size:CGSize,
                                     fps:UInt,
                                     complition:@escaping (_ url:URL?) -> Void) {
        // steps to convert
        // 1. Setup output path
        // 2. Setup AVAssetWriter
        // 3. Convert images to CGImage’s
        // 4. Finish AVAssetWriter session
        // 5. Export file with AVAssetExportSession
        
        // Setup output path
        guard let directory = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first else { complition(nil); return }
        let videoOutputPath = directory.appendingPathComponent(name + ".mov")
        
        // remove file if it's already exists
        if FileManager.default.fileExists(atPath: videoOutputPath.path) {
            try? FileManager.default.removeItem(at: videoOutputPath)
        }
        
        // Setup AVAssetWriter
        var videoWriter:AVAssetWriter? = nil
        do {
            videoWriter = try AVAssetWriter(outputURL: videoOutputPath, fileType: .mov)
        } catch { complition(nil); return }
        
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
        var frameCount:UInt = 0
        let frameDuration:UInt = 3
        
        // if cgImage is nil frame will be ignored which leads to missing frames
        for img in images {
            guard img.cgImage != nil else { continue }
            // TODO: Apply correct value
            buffer = pixelBufferFromCGImage(ref: img.cgImage!, size: CGSize(width: 464, height: 848))
            
            var isAppend = false
            var j = 0
            while(!isAppend && j < 30) {
                if adaptor.assetWriterInput.isReadyForMoreMediaData {
                    guard adaptor.assetWriterInput.isReadyForMoreMediaData else { continue }
                    let frameTime = CMTime(value: CMTimeValue(frameCount * frameDuration), timescale: __int32_t(fps))
                    guard buffer != nil else { complition(nil); return }
                    isAppend = adaptor.append(buffer!, withPresentationTime: frameTime)
                } else {
                    Thread.sleep(forTimeInterval: 0.1)
                }
                j += 1
            }
            frameCount += 1
        }
        
        // Finish AVAssetWriter session
        assetWriterInput.markAsFinished()
        videoWriter?.finishWriting {
            
            // Export file with AVAssetExportSession
            // create outup file
            let videoOutputFileUrl = URL(fileURLWithPath: videoOutputPath.path)
            let outputFilePath = directory.appendingPathComponent(name + ".mov")
            let outputFileUrl = URL(fileURLWithPath: outputFilePath.path)
            //        if FileManager.default.fileExists(atPath: outputFileUrl.path) {
            //            try? FileManager.default.removeItem(atPath: outputFileUrl.path)
            //        }
            
            // create asset
            let videoAsset = AVURLAsset(url: videoOutputFileUrl)
            let mixComposition = AVMutableComposition()
            let compositionTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
            try? compositionTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero,videoAsset.duration),
                                                   of: videoAsset.tracks(withMediaType: .video).first!,
                                                   at: kCMTimeZero)
            
            // export asset
            let assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
            assetExport?.outputFileType = AVFileType.mov
            assetExport?.outputURL = outputFileUrl
            assetExport?.exportAsynchronously(completionHandler: {
                complition(outputFileUrl)
            })
            
        }
    }
    
    static func pixelBufferFromCGImage(ref:CGImage, size:CGSize) -> CVPixelBuffer? {
        let options = [
            kCVPixelBufferCGImageCompatibilityKey : true,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true,
        ] as CFDictionary
        
        var buffer:CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(size.width),
                                         Int(size.height),
                                         kCVPixelFormatType_32ARGB,
                                         options,
                                         &buffer)
        guard status == kCVReturnSuccess else { return nil }
        
        CVPixelBufferLockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0))
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
    }
}































