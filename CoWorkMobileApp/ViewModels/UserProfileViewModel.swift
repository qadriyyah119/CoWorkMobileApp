//
//  UserProfileViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 2/13/24.
//

import UIKit

class UserProfileViewModel {
    
    var user: User? {
        didSet {
            if let user = user {
                print("User: \(user.username)")
//                userNameText = user.username
            }
        }
    }
    
    var userNameText: String? = "Brooklyn Afro"
    let logoutText: String = "Log Out"
    var userImage: String = "person.fill"
    var userImageCompletion: ((UIImage?) -> Void)?
    
    func getUser() {
        if let user = AuthManager.shared.currentUser {
            print("Current User: \(user.username)")
        } else {
            print("No User")
        }
    }
    
}
