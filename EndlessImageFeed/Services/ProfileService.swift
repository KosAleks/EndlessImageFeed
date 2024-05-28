//
//  ProfileService.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 16.03.2024.
//
import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init () {}
    
    private(set) var profile: Profile?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var token = OAuth2TokenStorage.shared.token
    private var lastToken: String?
    
    private func makeUserProfileRequest(token: String) -> URLRequest? {
        let urlString = "https://api.unsplash.com/me"
        
        guard let url = URL(string: urlString) else {
            print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        print(request)
        return request
    }
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile,Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        print(token)
        guard let request = makeUserProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            self.task = nil
            switch result {
            case .success(let response):
                // сохраняем полученные данные в ProfileStorage
                let resultStorage = ProfileStorage()
                resultStorage.userName = response.userName
                resultStorage.firstName = response.firstName ?? "No first name"
                resultStorage.lastName = response.lastName ?? "No last name"
                resultStorage.bio = response.bio ?? "No bio info"
                print(resultStorage.userName,resultStorage.firstName ,resultStorage.lastName, resultStorage.bio)
                
                let profileResult = ProfileResult(
                    userName: response.userName,
                    firstName: response.firstName,
                    lastName: response.lastName,
                    bio: response.bio ?? "No bio info"
                )
                
                self.profile = Profile(profileResult: profileResult)
                
                DispatchQueue.main.async{ [self] in
                    completion(.success(self.profile ?? Profile(username: "no user name", name: "no name", loginName: "no login name")))
                }
            case .failure(let error):
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }
    }
}



