//
//  WebViewViewControllerDelegate.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 23.02.2024.
//

import Foundation
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
