//
//  ProfileImageService.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 21.04.2024.
//

import Foundation
//final class ProfileImageService {
//    private let urlSession = URLSession.shared
//    private var task: URLSessionTask?
//    private var token = OAuth2TokenStorage.shared.token
//    static let shared = ProfileImageService()
//    init() {}
//    private (set) var profileImageURL: String?
//    
//    
////    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
////        task?.cancel()
////        guard let request = makeProfileImageRequest(token: token ?? "Error! No token") else {
////            completion(.failure(NetworkError.invalidRequest))
////            return
////        }
////        task = fetchProfileImageInfo(request: request) { [weak self] responce in
////            self?.task = nil
////            switch responce {
////            case .success(let result):
////                completion(.success(result.profileImage ?? "Error! No profile image."))
////                print("\(String(describing: result.profileImage))")
////            case .failure(let error):
////                completion(.failure(error))
////            }
////        }
////    }
////    
//    private func makeProfileImageRequest(token: String) -> URLRequest? {
//        let urlString = "https://api.unsplash.com//users/:username"
//        
//        guard let url = URL(string: urlString) else {
//            print("Failed to create URL with baseURL and parameters.")
//            return nil
//        }
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//        print(request)
//        return request
//    }
//    
//    func fetchProfileImageInfo(request: URLRequest, completion: @escaping (Result<ProfileResult,Error>) -> Void) -> URLSessionTask {
//        let _: (Result<ProfileResult,Error>) -> Void = {
//            result  in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//        let task = urlSession.dataTask(with: request) { [weak self] data, response, error  in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
//                    let error = NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
//                    completion(.failure(error))
//                    return
//                }
//                
//                guard let data = data else {
//                    let error = NSError(domain: "Data", code: -1, userInfo: nil)
//                    completion(.failure(error))
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    print(data)
//                    let response = try decoder.decode(ProfileResult.self, from: data)
//                    let resultFetchImageStorage = ProfileStorage()
//                    resultFetchImageStorage.profileImage = response.profileImage ?? "Error! No profile Image"
//                    let profileResult = ProfileResult(
//                        userName: response.userName,
//                        profileImage: response.profileImage
//                    )
//                    completion(.success(profileResult))
//                } catch {
//                    completion(.failure(error))
//                    self?.task = nil
//                }
//            }
//            guard (self?.task) != nil else {
//                return
//            }
//        }
//        task.resume()
//        return task
//    }
//}
