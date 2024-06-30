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
        completion: @escaping (Result<T, Error>) -> Void
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
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    fulfillCompletionOnTheMainThread(.failure(error))
                    print("\(NetworkError.urlRequestError(error))")
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                let statusCode = error.code
                DispatchQueue.main.async {
                    fulfillCompletionOnTheMainThread(.failure(error))
                    print("\(NetworkError.httpStatusCode(statusCode))")
                }
                return
            }
            guard let data = data else {
                let error = NSError(domain: "Data", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    fulfillCompletionOnTheMainThread(.failure(error))
                    print("\(NetworkError.dataError)")
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                let jSonString = String(data: data, encoding: .utf8)
                print("\(String(describing: jSonString))")
                DispatchQueue.main.async {
                    fulfillCompletionOnTheMainThread(.success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    fulfillCompletionOnTheMainThread(.failure(error))
                    print("Ошибка декодирования: (\(error.localizedDescription)")
                }
            }
        }
        task.resume()
        return task
    }
}
