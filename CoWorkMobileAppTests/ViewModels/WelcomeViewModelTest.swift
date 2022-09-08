//
//  WelcomeViewModelTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 8/9/22.
//

import XCTest
@testable import CoWorkMobileApp

class WelcomeViewModelTest: XCTestCase {
    
    var viewModel: WelcomeViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = WelcomeViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Initial State
    
    func testWelcomeView_whenCreated_loginButtonLabelText() {
        let text = viewModel.loginButtonText
        XCTAssertEqual(text, "LOG IN")
    }
    
    func testWelcomeView_whenCreated_registerButtonLabelText() {
        let text = viewModel.registerButtonText
        XCTAssertEqual(text, "REGISTER")
    }
    
    func testWelcomeView_whenCreated_skipButtonLabelText() {
        let text = viewModel.skipButtonText
        XCTAssertEqual(text, "SKIP")
    }
    
    func testWelcomeView_whenCreated_logoImage() {
        let logo = viewModel.logo
        XCTAssertEqual(logo, UIImage(imageLiteralResourceName: "Logo"))
    }

}
