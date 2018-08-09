//
//  VideoPlayerView.swift
//  Boomerang
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Aleksey Robul. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerView: UIView {
    
    // MARK: UI
    var playerLayer = AVPlayerLayer()
    /**
     Uses as background video playback behind blurView
     */
    var playerLayerBlur = AVPlayerLayer()
    
    // MARK: Proporties
    var player = AVPlayer()
    
    // MARK: Override funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        playerLayer.frame = self.bounds
        playerLayerBlur.frame = self.bounds
    }
    
    // MARK: Funcs
    func setVideo(withUrl url:URL){
        self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        self.player.play()
    }
}

extension VideoPlayerView {
    func setupUI() {
        self.backgroundColor = .lightGray
        
        playerLayerBlur.player = self.player
        playerLayerBlur.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayerBlur)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        blurView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        blurView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        playerLayer.player = self.player
        layer.addSublayer(playerLayer)
    }
}
























