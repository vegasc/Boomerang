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
    
    // MARK: UI
    let videoPlayer = VideoPlayerView()
    
    // MARK: Properties
    var imagePicker = UIImagePickerController()
    var speed = 30

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
}





























