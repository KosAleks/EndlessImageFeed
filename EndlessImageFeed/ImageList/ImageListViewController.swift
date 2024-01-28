//
//  ViewController.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 17.01.2024.
//

import UIKit

class ImageListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let photosName: [String] = Array(0..<20).map{("\($0)")}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    private lazy var dateFormated: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImageListViewController {
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        cell.imageCell.image = image
        cell.dataLabel.text = dateFormated.string(from: Date())
        cell.dataLabel.textColor = .white
        cell.dataLabel.font = .boldSystemFont(ofSize: 13)
        
        let isLiked = indexPath.row % 2 == 0
        let likedImage = isLiked ? UIImage(named: "Icon 42x42 ActiveLike") : UIImage(named: "Icon 42x42 NoActiveLike1")
        cell.likeButtonActive.setImage(likedImage, for: .normal)
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        guard let imageListcell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListcell, with: indexPath)
        return imageListcell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeidht = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeidht
    }
}


