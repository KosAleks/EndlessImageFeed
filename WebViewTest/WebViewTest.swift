//
//  WebViewTest.swift
//  WebViewTest
//
//  Created by Александра Коснырева on 19.06.2024.
//

@testable import EndlessImageFeed
import Foundation
import XCTest



final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "webViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testViewControllerDidCallRequest() {
        //given
        let controller = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        controller.presenter = presenter
        presenter.view = controller
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(controller.didCallRequest) //behaviour verification
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        let urlString = url?.absoluteString
        
        //then
        XCTAssertTrue(((urlString?.contains(configuration.authURLString)) != nil))
        XCTAssertTrue(((urlString?.contains(configuration.accessKey)) != nil))
        XCTAssertTrue(((urlString?.contains(configuration.redirectURI)) != nil))
        XCTAssertTrue(((urlString?.contains("code")) != nil))
        XCTAssertTrue(((urlString?.contains(configuration.accessScope)) != nil))
    }
    
    func testCodeFromURL() {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents?.url ?? URL(fileURLWithPath: "")
        let authHelper = AuthHelper()
        //when
           let code = authHelper.code(from: url)
           
           //then
           XCTAssertEqual(code, "test code")
    }
}











