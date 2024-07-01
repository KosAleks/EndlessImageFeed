//
//  Constants.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 21.02.2024.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: ApiConstants.accessKey,
                                 secretKey: ApiConstants.secretKey,
                                 redirectURI: ApiConstants.redirectURI,
                                 accessScope: ApiConstants.accessScope,
                                 authURLString: ApiConstants.unsplashAuthorizeURLString,
                                 defaultBaseURL: ApiConstants.defaultBaseURL ?? URL(fileURLWithPath: ""))
    }

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
