//
//  AccountRegistrationViewControllerTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 9/8/22.
//

import XCTest
@testable import CoWorkMobileApp

class AccountRegistrationViewControllerTest: XCTestCase {
    
    private var viewController: AccountRegistrationViewController!

    override func setUpWithError() throws {
       try super.setUpWithError()
        let viewModel = AccountRegistrationViewModel()
        viewController = AccountRegistrationViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        viewController = nil
        try super.tearDownWithError()
    }
    
    // MARK: Given

    
    // MARK: Initial
    
    func testAccountRegistrationViewController_whenLaunched_passwordShouldBeInvalid() {
        XCTAssertFalse(viewController.isPasswordValid, "Password field should be invalid when view first launches")
    }
    
    // Test complete invalid form
    
    func test_completeButton_formIsInvalid() {
        viewController.completeButton.sendActions(for: .primaryActionTriggered)
        viewController.creatingAccount = false
    }
    
    func test_completeButton_formIsInvalid_emailTextIsEmpty() {
        viewController.emailTextField.text = ""
    }
    
    func test_completeButton_formIsInvalid_usernameTextIsEmpty() {
        viewController.usernameTextField.text = ""
    }
    
    func test_completeButton_formIsInvalid_passwordTextIsEmpty() {
        viewController.passwordTextField.text = ""
    }
    
    func test_completeButton_formIsInvalid_passwordIsInvalid() {
        viewController.passwordTextField.text = "Hell0Fall1"
    }
    
    // Test complete valid form
    
    func test_completeButton_formIsValid() {
        viewController.emailTextField.text = "testing@gmail.com"
        viewController.usernameTextField.text = "Mary"
        viewController.passwordTextField.text = "Hell0Fall1!"
        viewController.completeButton.sendActions(for: .primaryActionTriggered)
    }
    
    // MARK: Form Validation
    

}

