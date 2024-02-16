//
//  User.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import RealmSwift

enum InvalidDataError: Error {
  case addingNonUniqueData
}

class User: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String?
    @Persisted var email: String
    @Persisted var username: String
    @Persisted var password: String
    @Persisted var salt: String
    @Persisted var profileImage: String?
    @Persisted var favorites = List<String>()
}

extension Realm {
    func addUnique<ObjectType: Object>(_ object: ObjectType.Type, uniqueKeyPath: String, value: String) throws {
        let realm = try Realm()

        let predicate = NSPredicate(format: "\(uniqueKeyPath) == %@", value)
        let existingObject = realm.objects(object).filter(predicate).first

            if existingObject != nil {
                // Handle the case where an object with the unique key already exists
                // For example, you might want to update the existing object or throw an error
                throw InvalidDataError.addingNonUniqueData
            }
    }
}

