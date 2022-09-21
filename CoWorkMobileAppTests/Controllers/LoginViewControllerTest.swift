//
//  LoginViewControllerTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 9/8/22.
//

import XCTest
@testable import CoWorkMobileApp

class LoginViewControllerTest: XCTestCase {
    
    private var viewController: LoginViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewController = LoginViewController()
    }

    override func tearDownWithError() throws {
        viewController = nil
        try super.tearDownWithError()
    }
    
    // MARK: Initial
    
    func testLoginViewController_ifAccountNotCreated_noUserShouldBeSignedIn() {
        XCTAssertFalse(viewController.signingIn, "No user should be signed in")
    }

}
