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
            videoPlayer.setVideo(withUrl: videoUrl)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}