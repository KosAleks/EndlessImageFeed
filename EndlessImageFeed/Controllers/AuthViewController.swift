//
//  AuthViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 21.02.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    private let authLogo = UIImageView()
    private let enterButton = UIButton()
    
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code) { result in
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Failed to fetch OAuth token with error: \(error)")
                vc.dismiss(animated: true)
                self.showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    deinit {
        print(">>>>>>> deinit")
    }
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = UIColor(named: "YP Black")
        configureBackButton()
        createLogo()
        createEnterButton()
    }
    private func createLogo() {
        view.addSubview(authLogo)
        authLogo.image = UIImage(named: "AuthLogo")
        authLogo.translatesAutoresizingMaskIntoConstraints = false
        authLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        authLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func createEnterButton(){
        view.addSubview(enterButton)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
        enterButton.backgroundColor = UIColor(named: "YP White")
        enterButton.setTitle("Войти", for: .normal)
        enterButton.layer.cornerRadius = 16
        enterButton.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        enterButton.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
        enterButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "navBackButton")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "navBackButton")
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    @objc private func didTapEnterButton() {
        guard let webViewViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "webViewViewController") as? WebViewViewController
        else {
            return
        }
        webViewViewController.delegate = self
        show(webViewViewController, sender: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

