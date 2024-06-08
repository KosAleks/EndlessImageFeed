//
//  ViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 17.01.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

final class ImageListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService()
    private (set) var photos = [Photo]()
    private let profileService = ProfileService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private let isLikedImage = UIImage(named: "Icon 42x42 ActiveLike")

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
            let photo = photos[indexPath.row]
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
//extension ImageListViewController {
//    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
//        let placeholder = UIImage(named: "placeholder")
//        cell.imageCell = UIImageView(image: placeholder)
//        cell.dataLabel.text = dateFormated.string(from: Date())
//    }
//}


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
        guard indexPath.row < photos.count else {
            // Если индекс выходит за границы, возвращаем пустую ячейку
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImageListCell
        else {
            return UITableViewCell()
        }
       
        imageListCell.delegate = self
        let photo = photos[indexPath.row]
        if let url = URL(string: photo.thumbImageURL ?? "") {
            imageListCell.imageCell.kf.setImage(with: url, completionHandler: { [weak self] _ in
                guard let self = self else {return}
            })
        }
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < photos.count else {
            return 0.0
        }
        let photo = photos[indexPath.row]
        let photoInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let photoViewWidth = tableView.bounds.width - photoInsets.right - photoInsets.left
        guard let photoWidth = photo.size?.width else { return 0.0 }
        let scale = photoViewWidth / photoWidth
        let cellHeidht = (photo.size?.height ?? 0.0) * scale + photoInsets.bottom
        return cellHeidht
    }
    
    private func  updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
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
        imagesListService.fetchPhotosNextPage(username: userName, completion: { [weak self] result in
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

extension ImageListViewController: ImagesListCellDelegate {
    
    func imagesListCellDidTapLike(_ cell: ImageListCell) {
    cell.likeButtonActive.setImage(self.isLikedImage, for: .normal)
      guard let indexPath = tableView.indexPath(for: cell) else { return }
      let photo = photos[indexPath.row]
      // Покажем лоадер
     UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id ?? "no photo id", isLike: !(photo.isLiked ?? false)!) { result in
        switch result {
        case .success:
           // Синхронизируем массив картинок с сервисом
           self.photos = self.imagesListService.photos
           // Изменим индикацию лайка картинки
              (self.photos[indexPath.row].isLiked)
           // Уберём лоадер
           UIBlockingProgressHUD.dismiss()
        case .failure:
           // Уберём лоадер
           UIBlockingProgressHUD.dismiss()
            let alert = UIAlertController(
                title: "Something is goinng wrong",
                message: "we are already fixing the problem, please wait",
                preferredStyle: .alert)
            alert.show(ImageListViewController(), sender: nil)
           }
        }
    }
}





