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
    private let imagesListViewController = ImageListViewController()
    let photo = Photo()
    weak var tableView: UITableView!
    var indexPath = IndexPath()
    weak var delegate: ImagesListCellDelegate?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        imageCell.kf.cancelDownloadTask()
        // Очищаем изображение, чтобы не показывать старое изображение при переиспользовании ячейки
        imageCell.image = nil
    }
    
  
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
    }

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImageListCell)
}
