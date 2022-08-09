//
//  AccountRegistrationViewModelTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 8/9/22.
//

import XCTest
@testable import CoWorkMobileApp

class AccountRegistrationViewModelTest: XCTestCase {
    
    func testAccountRegistrationViewText() {
        let viewModel = AccountRegistrationViewModel()
        
        XCTAssertEqual(viewModel.titleText, "Register")
        XCTAssertEqual(viewModel.emailPlaceholderText, "email")
        XCTAssertEqual(viewModel.usernamePlaceholderText, "username")
        XCTAssertEqual(viewModel.passwordPlaceholderText, "password")
        XCTAssertEqual(viewModel.completeButtonText, "SIGN UP")
        XCTAssertEqual(viewModel.registeringText, "CREATING ACCOUNT...")
    }
}
