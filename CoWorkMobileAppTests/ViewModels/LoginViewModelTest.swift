//
//  LoginViewModelTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 8/9/22.
//

import XCTest
@testable import CoWorkMobileApp

class LoginViewModelTest: XCTestCase {
    
    func testLoginViewText() {
        let viewModel = LoginViewModel()
        
        XCTAssertEqual(viewModel.titleText, "Log In")
        XCTAssertEqual(viewModel.emailPlaceholderText, "email")
        XCTAssertEqual(viewModel.passwordPlaceholderText, "password")
        XCTAssertEqual(viewModel.signInButtonText, "SIGN IN")
        XCTAssertEqual(viewModel.sigingInText, "SIGNING IN...")
    }
}
