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
        case invalidRequest
        case invalidData
        case unknownError
    }
    
    static let shared = AuthManager()
    
    var currentUser: User?
    
    func login(withEmail email: String, password: String, completion: @escaping(Result<User, AuthError>) -> Void) {
        let realm = try? Realm()
        let users = realm?.objects(User.self)
        
        guard let isValidUser = users?.first(where: {
            $0.email == email && $0.password == password
        }) else {
            completion(.failure(.invalidRequest))
            return
        }
        completion(.success(isValidUser))
    }
    
}

