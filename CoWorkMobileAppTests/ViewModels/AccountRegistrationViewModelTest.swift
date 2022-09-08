//
//  AccountRegistrationViewModelTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 8/9/22.
//

import XCTest
@testable import CoWorkMobileApp

class AccountRegistrationViewModelTest: XCTestCase {
    
    var viewModel: AccountRegistrationViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = AccountRegistrationViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Initial State
    
    func testAccountRegistrationView_whenCreated_titleLabelText() {
        let text = viewModel.titleText
        XCTAssertEqual(text, "Register")
    }
    
    func testAccountRegistrationView_whenCreated_emailPlaceHolderLabelText() {
        let text = viewModel.emailPlaceholderText
        XCTAssertEqual(text, "email")
    }
    
    func testAccountRegistrationView_whenCreated_usernamePlaceHolderLabelText() {
        let text = viewModel.usernamePlaceholderText
        XCTAssertEqual(text, "username")
    }
    
    func testAccountRegistrationView_whenCreated_passwordPlaceHolderLabelText() {
        let text = viewModel.passwordPlaceholderText
        XCTAssertEqual(text, "password")
    }
    
    func testAccountRegistrationView_whenCreated_completeButtonLabelText() {
        let text = viewModel.completeButtonText
        XCTAssertEqual(text, "SIGN UP")
    }
    
    // MARK: - Registration Progress
    
    func testAccountRegistrationView_whenSignUpTapped_accountCreationInProgress() {
        
    }
    
    // MARK: - Account Created
    
    func testAccountRegistrationView_whenUserSignsUp_accountIsCreated() {
        // given
        
    }

}
