//
//  User.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String?
    @Persisted var email: String
    @Persisted var username: String
    @Persisted var password: String
    @Persisted var profileImage: String?
    @Persisted var favorites = List<String>()
}
