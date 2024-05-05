//
//  WebViewViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 22.02.2024.
//

import Foundation
import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    private var estimatedObservation: NSKeyValueObservation?
    weak var authViewDelegate: WebViewViewControllerDelegate?
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("Something is going wrong. Wrong address or destination unreachable. Сheck that the url is correct.")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: ApiConstants.accessKey),
            URLQueryItem(name: "redirect_uri", value: ApiConstants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: ApiConstants.accessScope)
        ]
        guard let url = urlComponents.url else {
            print("Something is going wrong. Сheck that the url is correct.")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
        webView.navigationDelegate = self
        estimatedObservation = webView.observe(
            \.estimatedProgress,
             options: [],
            changeHandler: {[weak self] _, _ in
                guard let self = self else {return}
                self.updateProgress()
            })
    }
}

extension WebViewViewController:  WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                authViewDelegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}



