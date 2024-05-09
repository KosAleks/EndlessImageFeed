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
    private let oauth2Service = OAuth2Service.shared
    // private let showAuthenticationScreenSegue = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let token = OAuth2TokenStorage.shared.token
    
    private let imageLaunchScreen = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        create()
    }
    
    private func create() {
        view.backgroundColor = .green
        // view.backgroundColor  = UIColor(named: "YP Black")
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
        
        if token != nil {
            switchToTabBarController()
            fetchProfile(token: token ?? "No token at this moment.")
        } else {
            switchToAuthViewController()
        }
    }
    
    private func switchToAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
//        let navigationController = UINavigationController(rootViewController: authViewController)
//        navigationController.navigationBar.topItem?.title = ""
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
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
        guard let token = OAuth2TokenStorage.shared.token else {
            return
        }
        fetchProfile(token: token)
        switchToTabBarController()
    }
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        if OAuth2TokenStorage.shared.token != nil {
            profileService.fetchProfile(token: token, completion: { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                DispatchQueue.main.async { [self] in
//                                        guard let self = self else {
//                                            return
//                                        }
                    switch result {
                    case .success(_):
                        self?.profileImageService.fetchProfileImageURL(username: self?.profileService.profile?.username ?? "No username to feth profileImage", completion: { _ in})
                        self?.switchToTabBarController()
                    case .failure(_):
                        print("Failure. Something going wrong in fetch profile.")
                        break
                        
                    }
                }
            }
            )
        }
    }
}

