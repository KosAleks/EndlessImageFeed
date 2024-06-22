
//
//  ProfilePresenter.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 20.06.2024.
//

import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        print("3333333333===============33333333333")
    }
    
    func updateAvatar() {
        
    }
    
    func logout() {
        
    }
    
    func updateProfileDetails() {
        
    }
    
}

