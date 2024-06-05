//
//  ViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 17.01.2024.
//

import UIKit
import Kingfisher

final class ImageListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListservice = ImagesListService()
    private (set) var photos = [Photo]()
    private let profileService = ProfileService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private let placeholder = UIImage(named: "placeholder")
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
    if indexPath.row + 1 == photos.count  {
            fetchPhotos()
        } else {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        fetchPhotos()
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification ,
            object: nil,
            queue: .main)
        {[weak self] _ in
            guard let self = self else {return}
            self.updateTableViewAnimated()
        }
        updateTableViewAnimated()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ShowSingleImageSegueIdentifier {
    let viewController = segue.destination as! SingleImageViewController
    let indexPath = sender as! IndexPath
    let photo = imagesListservice.photos[indexPath.row]
    let imageURL = photo.thumbImageURL
         
    } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    private lazy var dateFormated: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
extension ImageListViewController {
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        cell.dataLabel.text = dateFormated.string(from: Date())
        let likedImage = UIImage(named: "Icon 42x42 NoActiveLike1")
        cell.likeButtonActive.setImage(likedImage, for: .normal)
    }
}


extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
}
extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImageListCell
        else {
            return UITableViewCell()
        }
        let photo = imagesListservice.photos[indexPath.row]
        if let url = URL(string: photo.thumbImageURL ?? "") {
            imageListCell.imageCell.kf.setImage(with: url, completionHandler: { [weak self] _ in
                guard let self = self else {return}
            })
        }
        return imageListCell
    }
                                           
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            let photo = imagesListservice.photos[indexPath.row]
            let photoInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            let photoViewWidth = tableView.bounds.width - photoInsets.right - photoInsets.left
            guard let photoWidth = photo.size?.width else { return 0.0 }
            let scale = photoViewWidth / photoWidth
            let cellHeidht = (photo.size?.height ?? 0.0) * scale + photoInsets.bottom
            return cellHeidht
        }
    
    private func  updateTableViewAnimated() {
              let oldCount = photos.count
              let newCount = imagesListservice.photos.count
              self.photos = imagesListservice.photos
              if oldCount != newCount {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
            }
    private func fetchPhotos() {
        guard let userName = profileService.profile?.username else {
            print("No user name to create a request for fetch profileImage")
            return
        }
        imagesListservice.fetchPhotosNextPage(username: userName, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newPhotos):
                // Добавляем новые фотографии в существующий массив
                self.photos.append(contentsOf: newPhotos)
                // Обновляем таблицу
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                // Обрабатываем ошибку, например, показываем пользователю сообщение
                print("Failed to fetch photos: \(error.localizedDescription)")
            }
        })
    }
    }
                                           
                                           
                                           
                                           
                                           
