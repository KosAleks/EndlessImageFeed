//
//  ImageViewCell.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 24.01.2024.
//

import Foundation
import UIKit

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    
    @IBOutlet var likeButtonActive: UIButton!
    @IBOutlet var dataLabel: UILabel!
    
    @IBOutlet var imageCell: UIImageView!
    
}
