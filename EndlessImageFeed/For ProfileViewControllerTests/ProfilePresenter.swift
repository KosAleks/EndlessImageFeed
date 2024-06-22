//
//  ProfilePresenter.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 20.06.2024.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func logout()
    func updateProfileDetails()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        updateAvatar()
        updateProfileDetails()
        logout()
        
    }
    
    func updateAvatar() {
            guard
                let profileImageURL = ProfileImageService.shared.profileImageURL,
                let url = URL(string: profileImageURL)
            else { return }
        view?.updateAvatar(url: url)
        }
    
    func logout() {
        profileLogoutService.logout()
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else {return}
        view?.updateProfileDetails(profile: profile)
    }
   
} 
