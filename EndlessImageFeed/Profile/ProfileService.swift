//
//  ProfileService.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 16.03.2024.
//
import Foundation
enum ProfileServiceError: Error {
    case invalidRequest
}
final class ProfileService {
    private let urlSession = URLSession.shared
    private var taskGet: URLSessionTask?//пеменная для хранения указателя на последнюю созданную задачу. Если активных задач нет, то значение будет nil.
    private var token = OAuth2TokenStorage.shared.token
    private var lastToken: String? // Переменная для хранения значения token, которое было передано в последнем созданном запросе.
    
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
    func fetchUserProfileResult(token: String, completion: @escaping (Result<ProfileResult,Error>) -> Void) {
        print(token)
        assert(Thread.isMainThread)
        if taskGet != nil { // Проверяем, выполняется ли в данный момент GET-запрос. Если да, то task != nil.
            if lastToken != token { // Проверяем соответствует ли текущий токен последнему использованному токену. Если они не совпадают, выполняется отмена текущей задачи.
                taskGet?.cancel() // отменяем выполнение задачи
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastToken == token { // здесь уже taskGet == nil, т.е.нет активных Get- запросов, но запрос с этим токеном уже выполнялся. В этом случае возвращается ошибка invalidRequest и выполнение запроса прерывается
                completion(.failure(AuthServiceError.invalidRequest))
                self.taskGet = nil
                self.lastToken = nil
                return
            }
        }
        lastToken = token
        guard let request = makeUserProfileRequest(token: token) else {
            return
        }
        taskGet = urlSession.dataTask(with: request) { [weak self] data, response, error  in
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
                    // Сохраняем полученныe данные в хранилище ResultStorage
                    let resultStorage = ProfileStorage()
                    print(response.userName, response.firstName, response.lastName, response.bio ?? "nothing")
                    resultStorage.userName = response.userName
                    resultStorage.firstName = response.firstName ?? "No first name"
                    resultStorage.lastName = response.lastName ?? "No last name"
                    resultStorage.bio = response.bio ?? "No bio info"
                    print(resultStorage.userName,resultStorage.firstName ,resultStorage.lastName, resultStorage.bio)
                    
                    let profileInfo = ProfileResult(
                        userName: response.userName,
                        firstName: response.firstName,
                        lastName: response.lastName,
                        bio: response.bio ?? "No bio info")
                    completion(.success(profileInfo))
                } catch {
                    completion(.failure(error))
                    self?.taskGet = nil
                }
            }
        }
        guard let taskGet = self.taskGet else {
            return
        }
        taskGet.resume()
    }
}

struct ProfileResult: Codable {
    var userName: String
    var firstName: String?
    var lastName: String?
    var bio: String?
}
enum CodingKeys: String, CodingKey{
    case userName = "username"
    case firstName = "first_name"
    case lastName = "last_name"
    case bio = "bio"
}

struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String
}

class ProfileStorage {
    var userName: String {
        get {
            // Возвращаем сохраненное значение имени пользователя из UserDefaults
            return UserDefaults.standard.string(forKey: "userName") ?? "There is no name"
        }
        set {
            // При установке нового значения имени пользователя сохраняем его в UserDefaults
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
    }
    var firstName: String {
        get {
            return UserDefaults.standard.string(forKey: "firstName") ?? "There is no firstName"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "firstName")
        }
    }
    var lastName: String {
        get {
            return UserDefaults.standard.string(forKey: "lastName") ?? "There is no lastName"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastName")
        }
    }
    var bio: String {
        get {
            return UserDefaults.standard.string(forKey: "bio") ?? "There is no bio"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bio")
        }
    }
}

