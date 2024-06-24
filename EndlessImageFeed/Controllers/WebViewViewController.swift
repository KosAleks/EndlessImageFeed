//
//  WebViewViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 22.02.2024.
//

import Foundation
import UIKit
import WebKit

final class WebViewViewController:  UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    private var estimatedObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
        presenter?.viewDidLoad()
        estimatedObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: {[weak self] _, _ in
                 guard let self = self else {return}
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
}

extension WebViewViewController:  WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            return ""
        }
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}



