//
//  WelcomeViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit

class WelcomeViewModel {
    
    enum LoginStrings {
        static let signinText = "Sign In"
        static let signingInText = "Signing In..."
        static let loginText = "LOG IN"
        static let registerText = "REGISTER"
        static let skipText = "SKIP"
    }
    
    let loginButtonText: String = LoginStrings.loginText
    let registerButtonText: String = LoginStrings.registerText
    let skipButtonText: String = LoginStrings.skipText
    let logo = UIImage(imageLiteralResourceName: "Logo")
    
}

