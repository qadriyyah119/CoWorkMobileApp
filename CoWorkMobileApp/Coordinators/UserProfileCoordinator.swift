//
//  UserProfileCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 2/13/24.
//

import UIKit

class UserProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType { .userProfile }
    weak var finishDelegate: CoordinatorFinishDelegate?
    var userId: String = ""
    var isLoggedIn: Bool = false
    
    private lazy var userProfileVC: UserProfileViewController = {
        let userProfileVC = UserProfileViewController()
        userProfileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        return userProfileVC
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        guard self.userId == AuthManager.shared.currentUser?.id else { return }
        self.navigationController.pushViewController(self.userProfileVC, animated: true)
    }
    
    func checkLogIn(completion: (() -> Void)?) {
        isLoggedIn = AuthManager.shared.currentUser != nil ? true : false
    }
    
}


