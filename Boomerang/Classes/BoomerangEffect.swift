//
//  BoomerangEffect.swift
//  Boomerang
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Aleksey Robul. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class BoomerangEffect {
    static func createBoomerangFrom(videoUrl:URL) -> [UIImage]? {
        // get image frame from video
        let getFrame:(_ fromTime:Float64, _ generator:AVAssetImageGenerator) -> UIImage? = { time, generator in
            let time:CMTime = CMTimeMakeWithSeconds(time, 600)
            let image:CGImage
            do {
                try image = generator.copyCGImage(at:time, actualTime:nil)
            }catch {
                return nil
            }
            return (UIImage(cgImage:image))
        }
        
        // prepeare asset
        let asset = AVAsset(url: videoUrl)
        let duration = CMTimeGetSeconds(asset.duration)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        // append frames
        var frames = [UIImage]()
        for i in 0..<Int(duration) {
            if let frame = getFrame(Float64(i), generator) {
                frames.append(frame)
            }
        }
        
        // return nil if there is no frames
        guard frames.count >= 1 else { return nil }
        
        // append reversed frames
        frames.append(contentsOf: frames.reversed())
        
        // convert to video
        
        return frames
    }
    
    
}








































