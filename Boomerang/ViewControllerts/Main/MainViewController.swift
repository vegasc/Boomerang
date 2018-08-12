//
//  ViewController.swift
//  Boomerang
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Aleksey Robul. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController {
    
    enum Speeds: Int {
        case min = 20
        case middle = 30
        case high = 50
    }
    
    // MARK: UI
    let videoPlayer = VideoPlayerView()
    let speedControl = UISegmentedControl()
    
    // MARK: Properties
    var imagePicker = UIImagePickerController()
    var speed = Speeds.middle // boomerang speed
    var originalUrl:URL? // url to the original video file

    // MARK: Lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAuthorization()
    }
    
    // MARK: Funcs
    @objc func openVideoGallery() {
        selectVideoFromLibrary()
    }
    
    @objc func saveVideoToCameraRoll() {
        if let url = self.videoPlayer.getVideoUrl() {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { (isSaved, error) in
                if isSaved {
                    self.showImageSavedAlert()
                }
            }
        }
    }
    
    @objc func updateSpeedValue() {
        switch speedControl.selectedSegmentIndex {
        case 0:
            speed = Speeds.min
            break
        case 1:
            speed = Speeds.middle
            break
        case 2:
            speed = Speeds.high
            break
        default:
            speed = Speeds.middle
            break
        }
        reloadVideo()
    }
    
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                break
            }
        }
    }
    
    func reloadVideo() {
        if let videoUrl = originalUrl {
            if let frames = BoomerangEffect.createBoomerangFrom(videoUrl: videoUrl) {
                // convert frames to video
                FileConverter.convertImagesToMovie(name: ".temp_boomerang",
                                                   images: frames,
                                                   fps: 30) { url in
                                                    if url != nil {
                                                        self.videoPlayer.setVideo(withUrl: url!)
                                                    }
                }
            }
        }
    }
}





























