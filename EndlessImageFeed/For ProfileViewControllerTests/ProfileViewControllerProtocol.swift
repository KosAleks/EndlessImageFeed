//
//  ProfileViewControllerProtocol.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 20.06.2024.
//

import Foundation
import Foundation
public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateProfileDetails(profile: Profile) 
}
