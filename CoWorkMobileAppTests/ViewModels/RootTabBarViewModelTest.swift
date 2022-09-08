//
//  RootTabBarViewModelTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 8/30/22.
//

import XCTest
@testable import CoWorkMobileApp

class RootTabBarViewModelTest: XCTestCase {
    
    var viewModel: RootTabBarViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = RootTabBarViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: Initial State
    
    func testTabBar_whenCreated_searchTabText() {
        let text = viewModel.searchTabTitle
        XCTAssertEqual(text, "Search")
    }
    
    func testTabBar_whenCreated_searchTabIcon() {
        let logo = viewModel.searchTabIcon
        XCTAssertEqual(logo, UIImage(systemName: "location.magnifyingglass"))
    }
    
    func testTabBar_whenCreated_collectionsTabText() {
        let text = viewModel.collectionsTabTitle
        XCTAssertEqual(text, "Collections")
    }
    
    func testTabBar_whenCreated_collectionsTabIcon() {
        let logo = viewModel.collectionsTabIcon
        XCTAssertEqual(logo, UIImage(systemName: "bookmark.fill"))
    }
    
    func testTabBar_whenCreated_profileTabText() {
        let text = viewModel.profileTabTitle
        XCTAssertEqual(text, "Profile")
    }
    
    func testTabBar_whenCreated_profileTabIcon() {
        let logo = viewModel.profileTabIcon
        XCTAssertEqual(logo, UIImage(systemName: "person.fill"))
    }

}
