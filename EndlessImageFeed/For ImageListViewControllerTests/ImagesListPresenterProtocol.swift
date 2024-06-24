//
//  ImageListPresenterProtocol.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 22.06.2024.
//

import Foundation
public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? {get set}
    func viewDidLoad()
    func fetchPhotos()
    func updateTableViewAnimated()
    func returnPhotoAtIndexPath(at indexPath: IndexPath) -> Photo
    func synchPhotos()
    //    func fetchNextPage(at indexPath: IndexPath)
    //    func getLargeImageURL(at indexPath: IndexPath) -> String?
    func photosCount() -> Int
    //    func getThumbImage(at indexPath: IndexPath) -> Photo?
   // func didTapLike(at indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void)
    func addObserver()
    func removeObserver()
}

final class ImagesPresenter: ImagesListPresenterProtocol {
    
    private (set) var photos = [Photo]()
    weak var view: ImagesListViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let imagesListService = ImagesListService()
    private var imageListServiceObserver: NSObjectProtocol?
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchPhotos()
        addObserver()
    }
    
    func fetchPhotos() {
        guard let userName = profileService.profile?.username else {
            print("No user name to create a request for fetch profileImage")
            return
        }
        imagesListService.fetchPhotosNextPage(username: userName) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.updateTableViewAnimated()
                case .failure(let error):
                    print("Failed to fetch photos: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func synchPhotos() {
        photos = imagesListService.photos
    }
    
    func updateTableViewAnimated() {
        let oldCount = self.photos.count
        let newCount = imagesListService.photos.count
        // обновили данные
        synchPhotos()
        if oldCount != newCount {
            DispatchQueue.main.async {
                self.view?.viewUpdateTableViewAnimated(oldCount: oldCount, newCount: newCount)
            }
        }
    }
    
    func returnPhotoAtIndexPath(at indexPath: IndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    
    func photosCount() -> Int {
        return photos.count
    }
    
    //    func  getThumbImage(at indexPath: IndexPath) -> Photo? {
    //        guard indexPath.row < photos.count else { return nil }
    //        return photos[indexPath.row]
    //    }
    //
//    func didTapLike(at indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void) {
//            self.view?.showProgressHud()
//            imagesListService.changeLike(photoId: photo.id ?? "no photo id", isLike: photo.isLiked ) { result in
//                switch result {
//                case .success(let photoIsLiked):
//                    self.photos[indexPath.row] = photoIsLiked
//                    self.view?.dismissProgressHud()
//                case .failure:
//                    self.view?.dismissProgressHud()
//                }
//            }
//        }
//
    func addObserver() {
        self.imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification ,
            object: nil,
            queue: .main)
        { [weak self] _ in
            guard let self = self else { return }
            let oldCount = self.photos.count
            let newCount = self.imagesListService.photos.count
            self.view?.viewUpdateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func removeObserver() {
        if let observer = self.imageListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
            self.imageListServiceObserver = nil
        }
    }
}
