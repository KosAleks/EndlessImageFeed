//
//  OAuth2Service.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 27.02.2024.
//

import Foundation
import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard URL(string: "https://unsplash.com") != nil else {
            print("Something is going wrong. Wrong address or destination unreachable. Check that the URL to request token is correct.")
            return nil
        }
        
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
    
    func fetchOAuthToken(code: String, completition: @escaping (Result<String,Error>) -> Void) {
        guard let urlRequest = makeOAuthTokenRequest(code: code) else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completition(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                completition(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "Data", code: -1, userInfo: nil)
                completition(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                // Сохраняем полученный токен в хранилище
                OAuth2TokenStorage.shared.token = response.accessToken
                completition(.success(response.accessToken))
            } catch {
                completition(.failure(error))
            }
        }
        task.resume()
    }
 }
