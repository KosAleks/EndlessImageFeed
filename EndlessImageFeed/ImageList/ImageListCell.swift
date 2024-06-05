//
//  ImageViewCell.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 24.01.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    @IBOutlet var likeButtonActive: UIButton!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var imageCell: UIImageView!
    private let imagesListService = ImagesListService()
    private let imageListViewController = ImageListViewController()
    private (set) var photos: [Photo] = []
    weak var tableView: UITableView! 
    var indexPath = IndexPath()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        imageCell.kf.cancelDownloadTask()
        // Очищаем изображение, чтобы не показывать старое изображение при переиспользовании ячейки
        imageCell.image = nil
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        let likedImage = UIImage(named: "Icon 42x42 ActiveLike")
        likeButtonActive.setImage(likedImage, for: .normal)
    }
    
}

