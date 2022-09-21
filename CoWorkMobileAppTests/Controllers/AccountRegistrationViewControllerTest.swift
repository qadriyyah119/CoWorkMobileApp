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
        viewController = AccountRegistrationViewController()
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
    
    // MARK: Form Validation
    

}

