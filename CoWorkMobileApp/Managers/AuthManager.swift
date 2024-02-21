//
//  AuthManager.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import Alamofire
import RealmSwift
import Combine
import CryptoKit

let passwordPattern = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[$@#!%*?&]).{8,}$")

class AuthManager {
    
    enum AuthError: Error {
        case invalidRequest
        case invalidData
        case userNotFound
        case wrongPassword
        case logOutError
        case unknownError
    }
    
    static let shared = AuthManager()
    
    var currentUserStatusPublisher = CurrentValueSubject<User?, Never>(nil)
    private(set) var currentUser: User?
        
    func login(withEmail email: String, password: String, completion: @escaping(Result<User, AuthError>) -> Void) {
        do {
            let realm = try Realm()
            if let user = realm.objects(User.self).filter("email == %@", email).first {
                
                if verifyPassword(inputPassword: password, storedHash: user.password, storedSalt: user.salt) {
                    setLoggedInUser(user: user)
                    completion(.success(user))
                } else {
                    completion(.failure(.wrongPassword))
                }
            } else {
                completion(.failure(.userNotFound))
            }
        } catch {
            completion(.failure(.unknownError))
        }
    }
    
    private func verifyPassword(inputPassword: String, storedHash: String, storedSalt: String) -> Bool {
        let saltedPassword = inputPassword + storedSalt
        guard let passwordData = saltedPassword.data(using: .utf8) else {
            return false
        }
        let hashedPassword = SHA256.hash(data: passwordData)
        let hashedPasswordString = hashedPassword.compactMap { String(format: "%02x", $0) }.joined()
        
        return hashedPasswordString == storedHash
    }
    
    func setLoggedInUser(user: User) {
        self.currentUser = user
        UserDefaults.standard.set(user.id, forKey: "currentUserId")
    }
    
    func logUserOut(userId: String, completion: @escaping(Bool) -> Void) {
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        currentUserStatusPublisher.send(nil)
        self.currentUser = nil
            completion(true)
    }
    
    func deleteUserAccount(userId id: String, password: String, completion: @escaping(Result<Bool, AuthError>) -> Void) {
        
        do {
            let realm = try Realm()
            if let user = realm.object(ofType: User.self, forPrimaryKey: id) {
                guard self.currentUser == user else { return completion(.failure(.userNotFound)) }
                
                if verifyPassword(inputPassword: password, storedHash: user.password, storedSalt: user.salt) {
                    try? realm.write {
                        realm.delete(user)
                    }
                    UserDefaults.standard.removeObject(forKey: "currentUserId")
                    self.currentUser = nil
                    currentUserStatusPublisher.send(nil)
                    completion(.success(true))
                } else {
                    completion(.failure(.wrongPassword))
                }
            } else {
                completion(.failure(.userNotFound))
            }
            
        } catch {
            completion(.failure(.unknownError))
        }
        
    }
    
}

