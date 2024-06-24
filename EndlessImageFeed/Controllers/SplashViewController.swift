//
//  SplashViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 04.03.2024.
//

import Foundation
import UIKit
import ProgressHUD
final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    private let storage = OAuth2TokenStorage.shared
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var token = OAuth2TokenStorage.shared.token
    
    private let imageLaunchScreen = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        create()
    }
    
    private func create() {
        view.backgroundColor  = UIColor(named: "YP Black")
        view.addSubview(imageLaunchScreen)
        imageLaunchScreen.image = UIImage(named: "ImageLaunchScreen")
        imageLaunchScreen.translatesAutoresizingMaskIntoConstraints = false
        imageLaunchScreen.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageLaunchScreen.widthAnchor.constraint(equalToConstant: 75).isActive = true
        imageLaunchScreen.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageLaunchScreen.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    private func switchToAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        let navVC = UINavigationController(rootViewController: authViewController)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(_):
                    self?.profileImageService.fetchProfileImageURL(username: self?.profileService.profile?.username ?? "No username to feth profileImage", completion: { _ in})
                    self?.switchToTabBarController()
                case .failure(_):
                    print("Failure. Something going wrong in fetch profile.")
                    self?.switchToAuthViewController()
                }
            }
        }
    }
}


