//
//  MainView.swift
//  Boomerang
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Aleksey Robul. All rights reserved.
//

import UIKit

extension MainViewController {
    func setupUI() {
        let purpleColor = UIColor.init(red: 103/255,
                                       green: 58/255,
                                       blue: 183/255,
                                       alpha: 1)
        self.title = "Boomerang"
        
        // setup navigation controller
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(openVideoGallery))
        addButton.tintColor = purpleColor
        self.navigationItem.rightBarButtonItem = addButton
        
        // setup view
        self.view.backgroundColor = .white
        
        self.view.addSubview(videoPlayer)
        videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        videoPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        videoPlayer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        videoPlayer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        videoPlayer.heightAnchor.constraint(equalToConstant: 300).isActive = true
        videoPlayer.clipsToBounds = true
        videoPlayer.layer.cornerRadius = 4.0
        
        let videoLabel = UILabel()
        view.addSubview(videoLabel)
        videoLabel.translatesAutoresizingMaskIntoConstraints = false
        videoLabel.bottomAnchor.constraint(equalTo: videoPlayer.topAnchor, constant: -20).isActive = true
        videoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        videoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        videoLabel.text = "Video player"
        videoLabel.textAlignment = .center
        
        let speedLabel = UILabel()
        view.addSubview(speedLabel)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.topAnchor.constraint(equalTo: videoPlayer.bottomAnchor, constant: 20).isActive = true
        speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        speedLabel.text = "Boomerang speed"
        speedLabel.textColor = purpleColor
        
        view.addSubview(speedControl)
        speedControl.translatesAutoresizingMaskIntoConstraints = false
        speedControl.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 10).isActive = true
        speedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        speedControl.insertSegment(withTitle: " 1x ", at: 0, animated: true)
        speedControl.insertSegment(withTitle: " 2x ", at: 1, animated: true)
        speedControl.insertSegment(withTitle: " 3x ", at: 2, animated: true)
        speedControl.tintColor = purpleColor
        speedControl.addTarget(self, action: #selector(updateSpeedValue), for: .valueChanged)
        
        let saveVideoButton = UIButton()
        view.addSubview(saveVideoButton)
        saveVideoButton.translatesAutoresizingMaskIntoConstraints = false
        saveVideoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        saveVideoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        saveVideoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveVideoButton.addTarget(self, action: #selector(saveVideoToCameraRoll), for: .touchUpInside)
        saveVideoButton.setTitle("Save video", for: .normal)
        saveVideoButton.backgroundColor = purpleColor
        saveVideoButton.layer.cornerRadius = 4.0
        
        updateSpeedControl()
    }
 
    func updateSpeedControl() {
        switch speed {
        case Speeds.min:
            speedControl.selectedSegmentIndex = 0
            break
        case Speeds.middle:
            speedControl.selectedSegmentIndex = 1
            break
        case Speeds.high:
            speedControl.selectedSegmentIndex = 2
            break
        }
    }
    
    func showImageSavedAlert() {
        let alert = UIAlertController(title: "⭐️",
                                      message: "Boomerang has been saved",
                                      preferredStyle: .alert)
        let okOption = UIAlertAction(title: "Ok",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okOption)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}






























