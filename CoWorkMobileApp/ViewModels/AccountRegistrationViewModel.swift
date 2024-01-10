//
//  AccountRegistrationViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit

class AccountRegistrationViewModel {
    
    var user: String = ""
    
    enum RegisterStrings {
        static let titleText = "Register"
        static let emailTextfieldText = "email"
        static let usernameTextfieldText = "username"
        static let passwordTextfieldText = "password"
        static let signUpText = "SIGN UP"
        static let registeringText = "CREATING ACCOUNT..."
    }
    
    let titleText: String = RegisterStrings.titleText
    let emailPlaceholderText: String = RegisterStrings.emailTextfieldText
    let usernamePlaceholderText: String = RegisterStrings.usernameTextfieldText
    let passwordPlaceholderText: String = RegisterStrings.passwordTextfieldText
    let completeButtonText: String = RegisterStrings.signUpText
    let registeringText: String = RegisterStrings.registeringText
    let passwordValidationText = NSMutableAttributedString (
        string: "Password must be at least 8 characters, and contain at least one upper case letter, one lower case letter, one number, and a special character.",
        attributes: [
            .font: UIFont(name: ThemeFonts.bodyFont, size: 12) ?? UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.black
        ])
    
    func userRegistered(withEmail email: String, password: String, completion: @escaping () -> Void) {
        AuthManager.shared.login(withEmail: email, password: password) { result in
            switch result {
            case .success(let user):
                print("User: \(user.username)")
                self.user = user.username
            case.failure(let error):
                print(error)
            }
            completion()
        }
    }
}

