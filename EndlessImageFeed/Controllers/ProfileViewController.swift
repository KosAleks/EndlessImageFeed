//
//  ProfileViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 31.01.2024.
//

import UIKit
import Kingfisher
final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private var profileStorage = ProfileStorage()
    private var token = OAuth2TokenStorage.shared.token
    private let userNameLabel = UILabel()
    private let userMailLabel = UILabel()
    private let greetingLabel = UILabel()
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileLogoutService = ProfileLogoutService.shared
    
    var profileAvatar = UIImageView()
    
    @objc func buttonTapped() {
        print("Button was tapped!")
        showAlertExit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = UIColor(named: "YP Black")
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main)
        { [weak self] _ in
            guard let self = self else {return}
            self.updateAvatar()
        }
        updateAvatar()
        
        view.addSubview(profileAvatar)
        profileAvatar.translatesAutoresizingMaskIntoConstraints = false
        profileAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let userNameLabel = UILabel()
        userNameLabel.textColor = UIColor(named: "YP White")
        userNameLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        view.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileAvatar.leadingAnchor).isActive = true
        
        let userMailLabel = UILabel()
        userMailLabel.textColor = UIColor(named: "YP Gray")
        userMailLabel.font = UIFont(name: "YSDisplay-Regular", size: 13)
        
        view.addSubview(userMailLabel)
        userMailLabel.translatesAutoresizingMaskIntoConstraints = false
        userMailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        userMailLabel.leadingAnchor.constraint(equalTo: profileAvatar.leadingAnchor).isActive = true
        
        let greetingLabel = UILabel()
        greetingLabel.textColor = UIColor(named: "YP White")
        greetingLabel.font = UIFont(name: "YSDisplay-Regular", size: 13)
        view.addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.topAnchor.constraint(equalTo: userMailLabel.bottomAnchor, constant: 8).isActive = true
        greetingLabel.leadingAnchor.constraint(equalTo: profileAvatar.leadingAnchor).isActive = true
        
        updateProfileDetails(profile: profileService.profile ?? Profile(username: "no userName", name: "no firstName, no lastName", loginName: "no loginName"))
        
        let exitButton =  UIButton(type: .system)
        exitButton.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        exitButton.tintColor = UIColor(named: "YP Red")
        
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor).isActive = true
        
        exitButton.addTarget(profileLogoutService.logout(),
                             action: #selector (buttonTapped) ,
                             for: .touchUpOutside)
        
        func updateProfileDetails(profile: Profile) {
            
            userNameLabel.text = profile.name
            userMailLabel.text = profile.loginName
            greetingLabel.text = profile.bio
            print("\(userNameLabel.text), \(userMailLabel.text) , \(greetingLabel.text)")
            return
        }
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        profileAvatar.kf.setImage(with: url)
        print("\(profileAvatar)")
    }
    
    private func showAlertExit() {
        let alert = UIAlertController(
            title: "Exit from account \(userNameLabel)",
            message: "Do you want to exit?",
            preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "Yes",
                                      style: .default) { _ in
            // переход на сплэшВьюКщнтроллер
        }
        
        let noButton = UIAlertAction(title: "No",
                                     style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true)
    }
}
// TODO: реализовать !!! при нажатии на кнопку выхода ажатию на кнопку выхода нужно показать предупреждение и запросить подтверждение выхода; если пользователь подтверждает выход из аккаунта, то:
//удаляется значение authToken из OAuth2TokenStorage;
//очищаются куки (cookie) веб-браузера (нужно вызывать HTTPCookieStorage.shared.removeCookies(since: .distantPast)) — в противном случае при открытии браузера не будут показаны поля для ввода логина и пароля;
//rootViewController заменяется на SplashViewController (выполняется по аналогии со switchToTabBarController, только нужно перейти не на TabBarController, а на SplashViewController).
//
