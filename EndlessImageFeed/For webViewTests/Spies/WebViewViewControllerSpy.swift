//
//  WebViewViewControllerSpy.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 19.06.2024.
//

import Foundation
final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: EndlessImageFeed.WebViewPresenterProtocol?
    var didCallRequest: Bool = false
    
    func load(request: URLRequest) {
        didCallRequest = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
