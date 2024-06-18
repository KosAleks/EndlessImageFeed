//
//  Constants.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 21.02.2024.
//

import Foundation

enum ApiConstants {
   static let accessKey = "0MlfABV_j7j5gj642vU8Ne_25wSBvZpWCunX8Zir_xY"
    static let secretKey = "lN6iAaCsMMO2WTpWeh_BOSvXpR4rdKQAgRWum0lCp2w"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
    static let grandType = "authorization_code"
    static let authURLString = "https://unsplash.com/oauth/authorize"
}

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
                                     authURLString: ApiConstants.authURLString,
                                     defaultBaseURL: ApiConstants.defaultBaseURL ?? URL(fileURLWithPath: "https://api.unsplash.com/"))
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
