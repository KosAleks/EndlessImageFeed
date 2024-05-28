//
//  Photo.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 24.05.2024.
//

import Foundation

struct PhotoResult: Codable {
    var id: String
    var createdAt: String
    var updatedAt: String
    var width: Double
    var height: Double
    var color: String
    var blurHash: String
    var likes: Int
    var likedByUser: Bool
    var description: String
    var urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey{
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width = "width"
        case height = "height"
        case color = "color"
        case blurHash = "blur_hash"
        case likes = "likes"
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls = "urls"
    }
}
   
struct UrlsResult: Codable {
    var raw: String?
    var full: String?
    var regular: String?
    var small: String?
    var thumb: String?
    
    private enum CodingKeys: String, CodingKey{
        case raw = "raw" // сырой, необработанный
        case full = "full" // полный
        case regular = "regular" // стандартный
        case small = "small"
        case thumb = "thumb" // миниатюра для предвариттельного простмотра
    }
}


struct Photo {
    var id: String
    var size: CGSize
    var createdAt: Date?
    var welcomeDescription: String?
    var thumbImageURL: String
    var largeImageURL: String
    var isLiked: Bool
}

extension Photo {
    init (photoResult: PhotoResult) {
        let dateFormatted = DateFormatter()
        let createdAtDate = dateFormatted.date(from: photoResult.createdAt)
        
        self.init(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: createdAtDate,
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb ?? "There is no thumb image URL",
            largeImageURL: photoResult.urls.full ?? "There is no large image URL (full)",
            isLiked: photoResult.likedByUser
        )
    }
}
