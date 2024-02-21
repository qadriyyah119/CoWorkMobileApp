//
//  UserProfileViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 2/13/24.
//

import UIKit
import Combine
import RealmSwift

class UserProfileViewModel: ObservableObject {
    
    var currentUser: User?
    
    var currentUserPublisher: AnyPublisher<User?, Never>
    var userSubscriptions = Set<AnyCancellable>()
    
    var userId: String = ""
    
    init(currentUserPublisher: AnyPublisher<User?, Never>){
        self.currentUserPublisher = currentUserPublisher
        subscribeToUserStatusChange()
    }
    
    @Published var userNameText: String = ""
    let logoutText: String = "Log Out"
    let deleteText: String = "Delete Account"
    var userImage: String = "person.fill"
    var userImageCompletion: ((UIImage?) -> Void)?
    
    func subscribeToUserStatusChange() {
        currentUserPublisher
            .sink { [weak self] currentUser in
                self?.updateUI(forUser: currentUser)
            }.store(in: &userSubscriptions)
    }
    
    private func updateUI(forUser user: User?) {
        if user == nil {
            self.userNameText = ""
        } else {
            if let user = user {
                self.userId = user.id
                getUser(withUserId: userId)
                self.userNameText = user.username
            }
        }
    }
    
    func getUser(withUserId id: String) {
        let realm = try? Realm()
        self.currentUser = realm?.object(ofType: User.self, forPrimaryKey: id)
    }
    
    func didTapLogOut(userId: String, completion: @escaping () -> Void) {
        AuthManager.shared.logUserOut(userId: userId) { success in
            print("Logged User Out Successfully!")
            }
        completion()
        }
    
    func didTapDeleteAccount(userId: String, completion: @escaping () -> Void) {
        
    }
    
}
