//
//  OAuth2Service.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 27.02.2024.
//

import Foundation
import UIKit


enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let urlString = "https://unsplash.com/oauth/token" +
        "?client_id=\(AccessKey)" +
        "&client_secret=\(SecretKey)" +
        "&redirect_uri=\(RedirectURI)" +
        "&code=\(code)" +
        "&grant_type=\(GrandType)"
        
        guard let url = URL(string: urlString) else {
            print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread) //чтобы избежать гонки обращаемся к task и lastCode из главного потока
        if task != nil { // Проверяем, выполняется ли в данный момент POST-запрос. Если да, то task != nil.
            if lastCode != code { // Проверяем, что в последнем запросе, который сейчас в процессе выполнения, значение code такое же, как в переданном аргументе. Если значение не совпадает, нужно отменить предыдущий запрос и выполнить новый.
                task?.cancel()
            } else {
                DispatchQueue.main.async {
                    completion(.failure(AuthServiceError.invalidRequest))
                }
                self.task = nil
                return
            }
        } else {
            if lastCode == code { // если значение совпадает, то ничего не делаем, - мы уже получили токен и запроса POST не идет
                DispatchQueue.main.async{
                    completion(.failure(AuthServiceError.invalidRequest))
                }
                return
            }
        }
        lastCode = code // запоминаем  code из запроса
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            DispatchQueue.main.async{
                completion(.failure(AuthServiceError.invalidRequest))
            }
            self.task = nil
            self.lastCode = nil
            return
        }
       task = urlSession.dataTask(with: request) { [weak self] data, response, error  in
            DispatchQueue.main.async {
                if let error = error {
                    DispatchQueue.main.async{
                        completion(.failure(error))
                    }
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    let error = NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                    DispatchQueue.main.async{
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "Data", code: -1, userInfo: nil)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    // Сохраняем полученный токен в хранилище
                    OAuth2TokenStorage.shared.token = response.accessToken
                    DispatchQueue.main.async {
                        completion(.success(response.accessToken))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                   // self?.task = nil
                   // self?.lastCode = nil
                }
            }
           guard let task = self?.task else {
               return
           }
           task.resume()
        }
    }
}

