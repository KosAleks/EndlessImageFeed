//
//  ImagesListService.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 24.05.2024.
//

import Foundation
import UIKit

final class ImagesListService {
    private var lastLoadedPage: Int = 0
    private (set) var photos = [Photo]()
    private var task: URLSessionTask?
    private let profileService = ProfileService.shared
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    
    private func makePhotosRequest() -> URLRequest? {
        let nextPage = lastLoadedPage + 1
        let perPage = 10
        let orderBy = "latest"
        let urlString = "https://api.unsplash.com/photos?page=\(nextPage)&per_page=\(perPage)&order_by=\(orderBy)"
        guard let url = URL(string: urlString) else {
            print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        var request = URLRequest(url: url)
        let token = OAuth2TokenStorage.shared.token
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            return request
        } else {
            print("no token to make request")
        }
        return nil
    }
    
    func fetchPhotosNextPage(username: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread) // обращаемся к task из главного потока
        if task != nil { // проверяем, выполняется ли в данный момент запрос. Если да, то task != nil.
            return
        }
        guard let request = makePhotosRequest() else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidRequest))
            }
            return
        }
        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            defer { self?.task = nil }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidRequest))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let photoResults = try decoder.decode([PhotoResult].self, from: data)
                let photo = photoResults.map { Photo(photoResult: $0) }
                DispatchQueue.main.async {
                    if let self = self {
                        self.photos.append(contentsOf: photo)
                        print("\(self.photos)")
                        self.lastLoadedPage = self.lastLoadedPage + 1
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self)
                        completion(.success(self.photos))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
    
    func makeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else {
            print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        var request = URLRequest(url: url)
        print("\(request)")
        let token = OAuth2TokenStorage.shared.token
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = isLike ? "DELETE" : "POST"
            return request
        } else {
            print("no token to make request")
        }
        return nil
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        assert(Thread.isMainThread)
        if self.task != nil {
            return
        }
        guard let likeRequest = makeLikeRequest(photoId: photoId, isLike: isLike) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidRequest))
            }
            return
        }
        task = urlSession.dataTask(with: likeRequest) { [weak self] data, response, error in
            defer { self?.task = nil }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidRequest))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let photoResult = try decoder.decode(PhotoResult.self, from: data)
                _ = Photo(photoResult: photoResult)
                DispatchQueue.main.async { [self] in
                    if let self = self {
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            let photo = self.photos[index]
                            let newPhoto = Photo(id: photo.id,
                                                 size: photo.size,
                                                 createdAt: photo.createdAt,
                                                 welcomeDescription: photo.welcomeDescription,
                                                 thumbImageURL: photo.thumbImageURL,
                                                 largeImageURL: photo.largeImageURL,
                                                 isLiked: !photo.isLiked)
                            self.photos[index] = newPhoto
                            completion(.success(newPhoto))
                        }
                        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}
    
extension ImagesListService {
    func cleanImagesList() {
        self.photos = []
    }
}

