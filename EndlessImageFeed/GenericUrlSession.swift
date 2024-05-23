//
//  GenericUrlSession.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 22.04.2024.
//

import Foundation

private weak var task: URLSessionTask?
extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping(Result<T, Error>)-> Void
    ) -> URLSessionTask {
        if task != nil {
            task?.cancel()
        }
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error  in
            DispatchQueue.main.async {
                if let error = error {
                    fulfillCompletionOnTheMainThread(.failure(error))
                    print("\(NetworkError.urlRequestError(error))")
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                let statusCode = error.code
                fulfillCompletionOnTheMainThread(.failure(error))
                print("\(NetworkError.httpStatusCode(statusCode))")
                return
            }
            guard let data = data else {
                let error = NSError(domain: "Data", code: -1, userInfo: nil)
                fulfillCompletionOnTheMainThread(.failure(error))
                print("\(NetworkError.dataError)")
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                let jSonString = String(data: data, encoding: .utf8)
                print("\(String(describing: jSonString))")
                fulfillCompletionOnTheMainThread(.success(response))
            } catch {
                fulfillCompletionOnTheMainThread(.failure(error))
                print("Ошибка декодирования: (\(error.localizedDescription)")
            }
        })
        task.resume()
        return task
    }
}


