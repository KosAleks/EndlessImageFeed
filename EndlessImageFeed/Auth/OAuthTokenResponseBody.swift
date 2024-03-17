//
//  OAuthTokenResponseBody.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 04.03.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey{
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}
