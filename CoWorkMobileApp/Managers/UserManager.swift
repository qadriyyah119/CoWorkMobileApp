//
//  UserManager.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import RealmSwift

class UserManager {
    
    static let shared = UserManager()
    
    func createUser(with email: String,
                    username: String,
                    password: String,
                    completion: @escaping(Result<Bool, Error>) -> Void) {
        
        let realm = try? Realm()
        
        do {
            let user = User()
            user.email = email
            user.username = username
            user.password = password
            
            try realm?.write {
                realm?.add(user)
                print("USER: \(user), \(user.id)")
            }
            let id = user.id
            UserDefaults.standard.set(id, forKey: "currentUserId")
            completion(.success(true))
        } catch let error {
            completion(.failure(error))
        }
    }
}

