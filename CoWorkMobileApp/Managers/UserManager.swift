//
//  UserManager.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import RealmSwift
import CryptoKit

class UserManager {
    
    enum UserError: Error, CaseIterable, CustomStringConvertible {
        case invalidPasswordData
        
        var description: String {
            switch self {
            case .invalidPasswordData: return "Failed to convert password data"
            }
        }
    }
    
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
            
            let passwordResult = try hashPassword(password)
            user.password = passwordResult.hashedPassword
            user.salt = passwordResult.salt
            
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
    
    private func hashPassword(_ password: String) throws -> (hashedPassword: String, salt: String) {
        let salt = randomSaltString(10)
        let saltedPassword = password + salt
        
        guard let passwordData = saltedPassword.data(using: .utf8) else { throw UserError.invalidPasswordData }
        
        let hashedPassword  = SHA256.hash(data: passwordData)
        let hashedPasswordString = hashedPassword.compactMap { String(format: "%02x", $0) }.joined()
        return (hashedPasswordString, salt)
    }
    
    private func randomSaltString(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        let saltString = (0..<length).map{ _ in String(letters.randomElement()!) }.reduce("", +)
        return saltString
    }
}

