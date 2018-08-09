//
//  MainPickerMethods.swift
//  Boomerang
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Aleksey Robul. All rights reserved.
//

import UIKit

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func selectVideoFromLibrary() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.movie"]
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let videoUrl = info["UIImagePickerControllerReferenceURL"] as? URL {
            if let frames = BoomerangEffect.createBoomerangFrom(videoUrl: videoUrl) {
                // convert frames to video
                if let url = FileConverter.convertImagesToMovie(name: ".temp_boomerang.mp4",
                                                                images: frames,
                                                                size: videoPlayer.bounds.size,
                                                                fps: 30) {
                    print("dd:\(url)")
                }
            }
//            videoPlayer.setVideo(withUrl: videoUrl)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
