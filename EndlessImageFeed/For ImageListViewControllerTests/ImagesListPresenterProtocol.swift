//
//  ImageListPresenterProtocol.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 22.06.2024.
//

import Foundation
public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    var photos: [Photo] {get set}
    func viewDidLoad()
    func fetchPhotos()
    func updateTableViewAnimated()
//    func fetchNextPage(at indexPath: IndexPath)
//    func getLargeImageURL(at indexPath: IndexPath) -> String?
    func photosCount() -> Int
//    func getThumbImage(at indexPath: IndexPath) -> Photo?
//    func didTapLike(at indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void)
//    func addObserver()
//    func removeObserver()
}

final class ImagesPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let imagesListService = ImagesListService()
    var photos = [Photo]()
    private var imageListServiceObserver: NSObjectProtocol?
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchPhotos()
        //       addObserver()
    }
    
    func fetchPhotos() {
        guard let userName = profileService.profile?.username else {
            print("No user name to create a request for fetch profileImage")
            return
        }
        imagesListService.fetchPhotosNextPage(username: userName) { result in
            switch result {
            case .success(_):
                self.updateTableViewAnimated()
            case .failure(let error):
                print("Failed to fetch photos: \(error.localizedDescription)")
            }
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = self.photos.count
        let newCount = imagesListService.photos.count
        // обновили данные
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.viewUpdateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }

//    func fetchNextPage(at indexPath: IndexPath) {
//        if indexPath.row + 1 == photos.count  {
//            self.fetchPhotos()
//        } else {
//            return
//        }
//    }
//
//    func getLargeImageURL(at indexPath: IndexPath) -> String? {
//        guard indexPath.row < photos.count else { return nil }
//        return photos[indexPath.row].largeImageURL
//    }

    func photosCount() -> Int {
        return self.photos.count
    }

//    func  getThumbImage(at indexPath: IndexPath) -> Photo? {
//        guard indexPath.row < photos.count else { return nil }
//        return photos[indexPath.row]
//    }
//
//    func didTapLike(at indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void) {
//        let photo = photos[indexPath.row]
//        view?.showProgressHud()
//        imagesListService.changeLike(photoId: photo.id ?? "no photo id", isLike: photo.isLiked ) { result in
//            switch result {
//            case .success(let photoIsLiked):
//                self.photos[indexPath.row] = photoIsLiked
//                self.view?.dismissProgressHud()
//            case .failure:
//                self.view?.dismissProgressHud()
//            }
//        }
//    }
//
//    func addObserver() {
//        self.imageListServiceObserver = NotificationCenter.default.addObserver(
//            forName: ImagesListService.didChangeNotification ,
//            object: nil,
//            queue: .main)
//        { [weak self] _ in
//            guard let self = self else {return}
//            view?.updateTableViewAnimated(oldCount: photos.count, newCount: imagesListService.photos.count)
//        }
//    }
//
//    func removeObserver() {
//        NotificationCenter.default.removeObserver(self.imageListServiceObserver ?? "")
//    }
}
