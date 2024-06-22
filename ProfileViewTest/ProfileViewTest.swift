//
//  ProfileViewTest.swift
//  ProfileViewTest
//
//  Created by Александра Коснырева on 21.06.2024.
//


import XCTest
@testable import EndlessImageFeed

final class ProfileViewTest: XCTestCase {
    
    func testProfileViewControllerCallsViewDidLoad() {
        // Given
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        profileViewController.presenter = presenter
        presenter.view = profileViewController
        
        // When
        profileViewController.loadViewIfNeeded() // Ensures viewDidLoad is called

        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled, "Expected viewDidLoad to be called on the presenter")
    }
}
