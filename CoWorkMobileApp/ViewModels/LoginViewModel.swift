//
//  LoginViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/8/22.
//

import UIKit

class LoginViewModel {
    
    enum LoginStrings {
        static let titleText = "Log In"
        static let emailTextfieldText = "email"
        static let passwordTextfieldText = "password"
        static let signInText = "SIGN IN"
        static let signingInText = "SIGNING IN..."
    }
    
    let titleText: String = LoginStrings.titleText
    let emailPlaceholderText: String = LoginStrings.emailTextfieldText
    let passwordPlaceholderText: String = LoginStrings.passwordTextfieldText
    let signInButtonText: String = LoginStrings.signInText
    let sigingInText: String = LoginStrings.signingInText
}
