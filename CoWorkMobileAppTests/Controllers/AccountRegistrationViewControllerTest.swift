//
//  AccountRegistrationViewControllerTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 9/8/22.
//

import XCTest
@testable import CoWorkMobileApp

class AccountRegistrationViewControllerTest: XCTestCase {
    
    var viewController: AccountRegistrationViewController!

    override func setUpWithError() throws {
       try super.setUpWithError()
        viewController = AccountRegistrationViewController()
    }

    override func tearDownWithError() throws {
        viewController = nil
        try super.tearDownWithError()
    }
    
    // MARK: Initial
    
    func testAccountRegistrationViewController_whenLaunched_passwordShouldBeInvalid() {
        XCTAssertFalse(viewController.isPasswordValid, "Password field should be invalid when view first launches")
    }
    
    // MARK: Form Validation
    
//    func testAccountRegistrationViewController_whenCompleteButtonTapped_buttonTextIsUpdated() {
//        let exp = expectation(description: "button title changed")
//        let observer = ButtonObserver()
//        observer.observe(viewController.completeButton, expectation: exp)
//        
//        viewController.createAccount()
//        
//        waitForExpectations(timeout: 1)
//        let text = viewController.completeButton.configuration?.title
//        XCTAssertEqual(text, AccountRegistrationViewModel.RegisterStrings.registeringText)
//    }

}
