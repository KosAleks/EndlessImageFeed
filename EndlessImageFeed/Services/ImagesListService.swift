//
//  ImagesListService.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 24.05.2024.
//

import Foundation

final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let profileService = ProfileService.shared
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    
    private func makePhotosRequest() -> URLRequest? {
        guard let userName = profileService.profile?.username else {
            print("No user name to create a request for fetch profileImage")
            return nil
        }
        let urlString = "https://api.unsplash.com/users/\(userName)/photos"
//        +
//        "?order_by=popular" +
//        "&orientation=portrait"
        
        guard let url = URL(string: urlString) else {
            print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print(request)
        return request
    }
    
    func fetchPhotosNextPage(username: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread) // обращаемся к task из главного потока
        // проверяем идет ли сейчас загрузка и если нет, то нужно создать новый сетевой запрос
        if task != nil { // проверяем, выполняется ли в данный момент запрос. Если да, то task != nil.
            return
        } else {

            // Здесь получим страницу номер 1, если ещё не загружали ничего,
            // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
            let nextPage = (lastLoadedPage ?? 0) + 1
            guard let request = makePhotosRequest() else {
                DispatchQueue.main.async{
                    completion(.failure(NetworkError.invalidRequest))
                }
                return
            }
            task = urlSession.objectTask(for:request) { (result: Result<PhotoResult, Error>) in
                switch result {
                case .success(let responce):
                    //сохраняем полученные данные в PhotoResult
                    let photosResult = PhotoResult(
                        id: responce.id,
                        createdAt: responce.createdAt,
                        updatedAt: responce.updatedAt,
                        width: responce.width,
                        height: responce.height,
                        color: responce.color,
                        blurHash: responce.blurHash,
                        likes: responce.likes,
                        likedByUser: responce.likedByUser,
                        description: responce.description,
                        urls: responce.urls)

                    self.photos = [Photo(photoResult: photosResult)]
                    DispatchQueue.main.async{
                        completion(.success(self.photos))
                    }

                case .failure(let error):
                    DispatchQueue.main.async{
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
