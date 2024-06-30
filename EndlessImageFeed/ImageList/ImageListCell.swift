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
    // MARK: IB Aoutlets
    @IBOutlet var likeButtonActive: UIButton!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var imageCell: UIImageView!
    
    // MARK: Public Properties
    weak var delegate: ImagesListCellDelegate?
    var indexPath = IndexPath()
    static let reuseIdentifier = "ImageListCell"
    
    // MARK: Private Properties
    private let isLikedImage = UIImage(named: "Icon 42x42 ActiveLike")
    private let isNotLikedImage = UIImage(named: "Icon 42x42 NoActiveLike1")
    
    // MARK: - View Life Cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
        imageCell.image = nil
    }
    
    // MARK: Public Properties
    func setIsLiked(isLike: Bool?) {
        let imageLike = isLike ?? true ? "Icon 42x42 ActiveLike" : "Icon 42x42 NoActiveLike1"
        likeButtonActive.accessibilityIdentifier = "likeButton"
        likeButtonActive.setImage(UIImage(named: imageLike), for: .normal)
    }
    
    // MARK: - IB Actions
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
}

// MARK: Protocol
protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImageListCell)
}

