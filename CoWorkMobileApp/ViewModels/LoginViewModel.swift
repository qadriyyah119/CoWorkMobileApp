//
//  LoginViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/8/22.
//

import UIKit

class LoginViewModel {
    
    var user: String = ""
    
    enum LoginStrings {
        static let titleText = "Enter your email and password to log in"
        static let emailTextfieldText = "Email"
        static let passwordTextfieldText = "Password"
        static let signInText = "SIGN IN"
        static let signingInText = "SIGNING IN..."
        static let orText = "OR"
        static let registerText = "New to CoWork?"
        static let registerButtonText = "Register"
    }
    
    let titleText: String = LoginStrings.titleText
    let emailPlaceholderText: String = LoginStrings.emailTextfieldText
    let passwordPlaceholderText: String = LoginStrings.passwordTextfieldText
    let signInButtonText: String = LoginStrings.signInText
    let sigingInText: String = LoginStrings.signingInText
    let orText: String = LoginStrings.orText
    let registerText: String = LoginStrings.registerText
    let registerButtonText: String = LoginStrings.registerButtonText
    
    
    func didTapLogin(withEmail email: String, password: String, completion: @escaping(Result<String, AuthManager.AuthError>) -> Void) {
        AuthManager.shared.login(withEmail: email, password: password) { result in
            switch result {
            case .success(let user):
                print("User: \(user.username)")
                self.user = user.username
                completion(.success(self.user))
            case.failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
}
