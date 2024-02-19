//
//  UserProfileViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 2/13/24.
//

import UIKit
import Combine
import RealmSwift

class UserProfileViewModel {
    
    var currentUser: User? {
        didSet {
            if let user = currentUser {
                print("User: \(user.username)")
                userNameText = user.username

            }
        }
    }
    
    var userId: String = ""
    
    init(userId: String){
        self.userId = userId
        getUser(withUserId: userId)
    }
    
    var userNameText: String? = ""
    let logoutText: String = "Log Out"
    let deleteText: String = "Delete Account"
    var userImage: String = "person.fill"
    var userImageCompletion: ((UIImage?) -> Void)?
    
    func getUser(withUserId id: String) {
        let realm = try? Realm()
        self.currentUser = realm?.object(ofType: User.self, forPrimaryKey: id)
    }
    
}
