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
