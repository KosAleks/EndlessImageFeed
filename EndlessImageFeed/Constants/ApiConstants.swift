//
//  ApiConstants.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 01.07.2024.
//

import Foundation

enum ApiConstants {
   static let accessKey = "0MlfABV_j7j5gj642vU8Ne_25wSBvZpWCunX8Zir_xY"
    static let secretKey = "lN6iAaCsMMO2WTpWeh_BOSvXpR4rdKQAgRWum0lCp2w"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
    static let grandType = "authorization_code"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

