//
//  ProfileViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 31.01.2024.
//

import UIKit
final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "YP Black")
        let profileImage = UIImage(named: "userPhoto")
        let imageView = UIImageView(image: profileImage)
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let userNameLabel = UILabel()
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.textColor = UIColor(named: "YP White")
        userNameLabel.font = UIFont(name: "Display", size: 23)
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        view.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        let userMailLabel = UILabel()
        userMailLabel.text = "@ekaterina_nov"
        userMailLabel.textColor = UIColor(named: "YP Gray")
        userMailLabel.font = UIFont(name: "Display", size: 13)
        
        view.addSubview(userMailLabel)
        userMailLabel.translatesAutoresizingMaskIntoConstraints = false
        userMailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        userMailLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        let greetingLabel = UILabel()
        greetingLabel.text = "Hello, world!"
        greetingLabel.textColor = UIColor(named: "YP White")
        greetingLabel.font = UIFont(name: "Display", size: 13)
        view.addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.topAnchor.constraint(equalTo: userMailLabel.bottomAnchor, constant: 8).isActive = true
        greetingLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        let exitButton =  UIButton(type: .system)
        exitButton.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        exitButton.tintColor = UIColor(named: "YP Red")
        
      
        
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
}

    
    
    
 
