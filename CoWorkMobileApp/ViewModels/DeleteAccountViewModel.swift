//
//  DeleteAccountViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 2/20/24.
//

import UIKit

class DeleteAccountViewModel {
    
    let titleText: String = "Delete Account"
    let messageText: String = "To delete account, enter password."
    let passwordPlaceholderText: String = "Enter Password"
    let cancelButtonText: String = "Cancel"
    let deleteButtonText: String = "Delete Account"
    var userId: String = ""
    
    init(userId: String){
        self.userId = userId
    }
    
    func didTapDeleteAccount(userId: String, password: String, completion: @escaping () -> Void) {
        AuthManager.shared.deleteUserAccount(userId: userId, password: password) { result in
            switch result {
            case .success(let success):
                print("Account Successfully Deleted \(success)")
            case .failure(let error):
                print(error)
            }
        }
        completion()
    }
}
