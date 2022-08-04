//
//  AuthManager.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import Alamofire
import RealmSwift

let passwordPattern = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[$@#!%*?&]).{8,}$")

class AuthManager {
    
    enum AuthError: Error {
        case invalidPassword
        case invalidEmail
        case emailAlreadyInUse
        case usernameAlreadyInUse
        case unknownError
    }
    
    static let shared = AuthManager()
    
    var currentUser: User?

}

