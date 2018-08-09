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
    
    // MARK: Proporties
    var player = AVPlayer()
    var playerController = AVPlayerViewController()
    /**
     Uses for background video playback in blurView
     */
    lazy var playerLayer: AVPlayerLayer = {
        return AVPlayerLayer(player: self.player)
    }()
    
    // MARK: Lifecycle funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Funcs
    func setVideo(withUrl url:URL){
        self.player = AVPlayer(url: url)
        self.playerController.player = self.player
        self.playerController.player?.play()
    }
}

extension VideoPlayerView {
    func setupUI() {
        self.playerController.view.frame = self.frame
        self.playerController.showsPlaybackControls = false
        self.playerController.view.backgroundColor = .lightGray
        addSubview(self.playerController.view)
        
        let blurView = UIView()
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        blurView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        blurView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
}
























