//
//  ProfileImageService.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 21.04.2024.
//

import Foundation
final class ProfileImageService {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var token = OAuth2TokenStorage.shared.token
    static let shared = ProfileImageService()
    init() {}
    private (set) var profileImageURL: String?
    private var profileImage = ProfileImage()
    private var profileService = ProfileService.shared
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    
    private func makeProfileImageRequest() -> URLRequest? {
        guard let userName = profileService.profile?.username else {
            print("No user name to create a request for fetch profileImage")
            return nil
        }
        
        let urlString = "https://api.unsplash.com/users/\(userName)"
        
        guard let url = URL(string: urlString) else {
            print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        var request = URLRequest(url: url)
        
        let token = OAuth2TokenStorage.shared.token
        if token != nil {
            request.setValue("Bearer \(token ?? "her vam a ne token")", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            return request
        }
        else { print("no token to make request") }
        return nil
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request1 = makeProfileImageRequest()else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask(for: request1) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let response):
              
                guard let profileImageURL = response.profileImage.small else {return}
                self?.profileImageURL = profileImageURL
               
                DispatchQueue.main.async {
                    completion(.success(profileImageURL))
                    NotificationCenter.default.post (
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL]
                    )
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("\(result)")
                    print("\(error)")
                    completion(.failure(error))
                }
            }
        }
        
    }
}
