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
        self.title = "Boomerang"
        // setup navigation controller
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(openVideoGallery))
        self.navigationItem.rightBarButtonItem = addButton
        
        // setup view
        self.view.backgroundColor = .white
        
        self.view.addSubview(videoPlayer)
        videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        videoPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        videoPlayer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        videoPlayer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        videoPlayer.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        let videoLabel = UILabel()
        view.addSubview(videoLabel)
        videoLabel.translatesAutoresizingMaskIntoConstraints = false
        videoLabel.bottomAnchor.constraint(equalTo: videoPlayer.topAnchor, constant: -20).isActive = true
        videoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        videoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        videoLabel.text = "Video player"
        videoLabel.textAlignment = .center
    }
}






























