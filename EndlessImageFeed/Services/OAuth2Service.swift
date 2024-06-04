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
        "?client_id=\(ApiConstants.accessKey)" +
        "&client_secret=\(ApiConstants.secretKey)" +
        "&redirect_uri=\(ApiConstants.redirectURI)" +
        "&code=\(code)" +
        "&grant_type=\(ApiConstants.grandType)"
        
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
                completion(.failure(AuthServiceError.invalidRequest))
                self.task = nil
                return
            }
        } else {
            if lastCode == code { // если значение совпадает, то ничего не делаем, - мы уже получили токен и запроса POST не идет
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code // запоминаем  code из запроса
        guard let request = makeOAuthTokenRequest(code: code)
        else {
            DispatchQueue.main.async{
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            self.task = nil
            self.lastCode = nil
            switch result {
            case .success(let response):
                OAuth2TokenStorage.shared.token = response.accessToken
                DispatchQueue.main.async {
                    completion(.success(response.accessToken))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}



