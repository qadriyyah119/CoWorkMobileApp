//
//  UserProfileContentViewViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 1/30/24.
//

import UIKit
import RealmSwift

class UserProfileContentViewViewModel {
    
    var user: User? {
        didSet {
            if let user = user {
                print("User: \(user.username)")
                userNameText = user.username
            }
        }
    }
    
    var userNameText: String?
    var userImage = UIImage(systemName: "person.fill")
    var userImageCompletion: ((UIImage?) -> Void)?
    let logoutText = NSAttributedString (
        string: "Log Out",
        attributes: [
            .foregroundColor: UIColor.black
        ])
    
    func fill(withUserId id: String, completion: (() -> Void)? ) {
        let realm = try? Realm()
        self.user = realm?.object(ofType: User.self, forPrimaryKey: id)
        completion?()
    }
}
