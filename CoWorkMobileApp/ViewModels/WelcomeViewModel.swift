//
//  WelcomeViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit

class WelcomeViewModel {
    
    weak var coordinator: AppCoordinator?

    enum LoginStrings {
        static let loginText = "LOG IN"
        static let registerText = "REGISTER"
        static let skipText = "SKIP"
    }

    let loginButtonText: String = LoginStrings.loginText
    let registerButtonText: String = LoginStrings.registerText
    let skipButtonText: String = LoginStrings.skipText
    let logo = UIImage(imageLiteralResourceName: "Logo")
    
    func showLoginView() {
        coordinator?.showLoginView()
    }
    
    func showRegistrationView() {
        coordinator?.showRegistrationView()
    }
    
    func showMainFlow() {
        coordinator?.showMainFlow()
    }

}

