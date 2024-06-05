//
//  ImagesListService.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 24.05.2024.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let profileService = ProfileService.shared
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private var photoResult = PhotoResult()
    
    
    private func makePhotosRequest() -> URLRequest? {
        let nextPage = (lastLoadedPage ?? 0) + 1
        let perPage = 10
        let orderBy = "latest"
        let urlString = "https://api.unsplash.com/photos?page=\(nextPage)"+"&per_page=\(perPage)"+"&order_by=\(orderBy)"
        
        guard let url = URL(string: urlString) else {
            print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        
        var request = URLRequest(url: url)
        let token = OAuth2TokenStorage.shared.token
        if token != nil {
            request.setValue("Bearer \(token ?? "no token to make request for fetch photos")", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            print(">>>>>>>>>>>>>>>>>>>>>\(request)")
            return request
        } else { print("no token to make request") }
        return request
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
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidRequest))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let photoResults = try decoder.decode([PhotoResult].self, from: data)
                let photos = photoResults.map { Photo(photoResult: $0) }
                
                DispatchQueue.main.async {
                    
                    if let self = self {
                        self.photos.append(contentsOf: photos)
                        self.lastLoadedPage = (self.lastLoadedPage ?? 0) + 1
                        DispatchQueue.main.async {
                            completion(.success(self.photos))
                        }
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




