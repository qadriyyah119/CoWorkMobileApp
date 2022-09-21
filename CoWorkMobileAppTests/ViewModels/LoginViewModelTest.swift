//
//  LoginViewModelTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 8/9/22.
//

import XCTest
@testable import CoWorkMobileApp

class LoginViewModelTest: XCTestCase {
    
    private var viewModel: LoginViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = LoginViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: Initial State
    
    func testLoginView_whenCreated_titleLabelText() {
        let text = viewModel.titleText
        XCTAssertEqual(text, "Log In")
    }
    
    func testLoginView_whenCreated_emailPlaceholderText() {
        let text = viewModel.emailPlaceholderText
        XCTAssertEqual(text, "email")
    }
    
    func testLoginView_whenCreated_passwordPlaceholderText() {
        let text = viewModel.passwordPlaceholderText
        XCTAssertEqual(text, "password")
    }
    
    func testLoginView_whenCreated_signInButtonText() {
        let text = viewModel.signInButtonText
        XCTAssertEqual(text, "SIGN IN")
    }
    
    func testLoginView_whenCreated_sigingInText() {
        let text = viewModel.sigingInText
        XCTAssertEqual(text, "SIGNING IN...")
    }

}
