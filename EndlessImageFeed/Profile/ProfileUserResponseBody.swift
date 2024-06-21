//
//  ProfileUserResponseBody.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 18.03.2024.
//

import Foundation

struct ProfileResult: Codable {
    var userName: String
    var firstName: String?
    var lastName: String?
    var bio: String?
    
    
    private enum CodingKeys: String, CodingKey{
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct UserResult: Codable {
    var profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage : Codable {
    var small: String?
    var medium: String?
    var large: String?
    
    private enum CodingKeys: String, CodingKey {
        case small = "small"
        case medium = "medium"
        case large = "large"
        
    }
}

public struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
}

extension Profile {
    
    init(profileResult: ProfileResult) {
        self.init(
            username: profileResult.userName,
            name: "\(profileResult.firstName ?? "no data firstName")" + " " + "\(profileResult.lastName ?? "no data lastName")",
            loginName: "@" + "\(profileResult.userName)",
            bio: profileResult.bio ?? "no bio"
        )
    }
    
}


