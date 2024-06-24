//
//  ImageListViewControllerProtocol.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 22.06.2024.
//

import Foundation
public protocol ImagesListViewControllerProtocol: AnyObject {
    var imagesPresenter: ImagesListPresenterProtocol? {get set}
   // func configure()
     func viewUpdateTableViewAnimated(oldCount: Int, newCount: Int)
    // func showProgressHud()
    // func dismissProgressHud()
}
