//
//  SplashViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 04.03.2024.
//

import Foundation
import UIKit
import ProgressHUD
final class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service.shared
    private let showAuthenticationScreenSegue = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let token = OAuth2TokenStorage.shared.token
    
    func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        if OAuth2TokenStorage.shared.token != nil {
            profileService.fetchProfile(token: token, completion: { [weak self] result in
                DispatchQueue.main.async {
                    
                    
                    UIBlockingProgressHUD.dismiss()
                    guard let self = self else {
                        return
                    }
                    switch result {
                    case .success(_):
                        self.switchToTabBarController()
                    case .failure(_):
                        print("Failure. Something going wrong in fetch profile.")
                        break
                    }
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegue, sender: nil)
        }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegue {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegue)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = OAuth2TokenStorage.shared.token else {
            return
        }
        fetchProfile(token: token)
        // убедиться что функция fetchProfile(token: token) вызывается не только после непосредственно авторизации, но и если authToken уже присутствует на момент запуска из метода viewDidAppear.
        switchToTabBarController()
    }
}
