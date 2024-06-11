//
//  Photo.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 24.05.2024.
//

import Foundation
import CoreGraphics

struct PhotoResult: Codable {
    var id: String?
    var createdAt: String?
    var width: Int?
    var height: Int?
    var likedByUser: Bool?
    var description: String?
    var urls: UrlsResult?
    
    private enum CodingKeys: String, CodingKey{
        case id
        case createdAt = "created_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct UrlsResult: Codable {
    var raw: String?
    var full: String?
    var regular: String?
    var small: String?
    var thumb: String?
    
    private enum CodingKeys: String, CodingKey{
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct Photo: Codable {
    var id: String?
    var size: CGSize?
    var createdAt: String?
    var welcomeDescription: String?
    var thumbImageURL: String?
    var largeImageURL: String?
    var isLiked: Bool
}

extension Photo {
    init (photoResult: PhotoResult) {
        
        let size: CGSize? = {
            guard let width = photoResult.width, let height = photoResult.height, width > 0, height > 0 else {
                return nil
            }
            return CGSize(width: Double(width), height: Double(height))
        }()
        
        self.init(
            id: photoResult.id ?? "There is no id in fetch photo",
            size: size,
            createdAt: photoResult.createdAt,
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls?.thumb ?? "There is no thumb image URL",
            largeImageURL: photoResult.urls?.full ?? "There is no large image URL (full)",
            isLiked: photoResult.likedByUser ?? false
        )
    }
}
