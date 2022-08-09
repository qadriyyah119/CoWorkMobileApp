//
//  WelcomeViewModelTest.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 8/9/22.
//

import XCTest
@testable import CoWorkMobileApp

class WelcomeViewModelTest: XCTestCase {
    
    func testWelcomeViewText() {
        let viewModel = WelcomeViewModel()
        
        XCTAssertEqual(viewModel.loginButtonText, "LOG IN")
        XCTAssertEqual(viewModel.registerButtonText, "REGISTER")
        XCTAssertEqual(viewModel.skipButtonText, "SKIP")
        XCTAssertEqual(viewModel.logo, UIImage(imageLiteralResourceName: "Logo"))
    }
}
