//
//  ButtonObserver.swift
//  CoWorkMobileAppTests
//
//  Created by Qadriyyah Thomas on 9/8/22.
//

import XCTest

class ButtonObserver {
    var token: NSKeyValueObservation?
    
    func observe(_ button: UIButton, expectation: XCTestExpectation) {
        token = button.observe(\.titleLabel?.text, options: [.new]) { _, _ in
            expectation.fulfill()
        }
    }
    
    deinit {
        token?.invalidate()
    }
}
