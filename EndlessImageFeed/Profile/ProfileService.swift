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
        task?.cancel()
        print(token)
        guard let request = makeUserProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        task = fetchProfileBody(request: request) { [weak self] responce in
            self?.task = nil
            switch responce {
            case .success(let profileResult):
                self?.profile = Profile(profileResult: profileResult)
               
                completion(.success(self?.profile ?? Profile(username: "no userName", name: "no first name and last name", loginName: "no loginName")))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchProfileBody(request: URLRequest, completion: @escaping (Result<ProfileResult,Error>) -> Void) -> URLSessionTask {
        let _: (Result<ProfileResult,Error>) -> Void = {
            result  in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error  in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    let error = NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "Data", code: -1, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    // decoder.keyDecodingStrategy = .convertFromSnakeCase
                    print(data)
                    let response = try decoder.decode(ProfileResult.self, from: data)
                    print("\(response)")
                    // сохраняем полученные данные в ProfileStorage
                    let resultStorage = ProfileStorage()
                    resultStorage.userName = response.userName
                    resultStorage.firstName = response.firstName ?? "No first name"
                    resultStorage.lastName = response.lastName ?? "No last name"
                    resultStorage.bio = response.bio ?? "No bio info"
                    print(resultStorage.userName,resultStorage.firstName ,resultStorage.lastName, resultStorage.bio)
                    
                    let profile = ProfileResult(
                        userName: response.userName,
                        firstName: response.firstName,
                        lastName: response.lastName,
                        bio: response.bio ?? "No bio info")
                    completion(.success(profile))
                    print("\(profile)")
                    
                } catch {
                    completion(.failure(error))
                    self?.task = nil
                }
            }
            guard (self?.task) != nil else {
                return
            }
        }
        task.resume()
        return task
    }
}








