//
//  WebViewViewControllerProtocol.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 18.06.2024.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
