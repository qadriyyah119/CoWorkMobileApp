//
//  UserProfileCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 2/13/24.
//

import UIKit
import Combine

class UserProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType { .userProfile }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var parentCoordinator: RootTabBarCoordinator?
    var currentUserPublisher: AnyPublisher<User?, Never>
    var subscriptons = Set<AnyCancellable>()
    var userId: String = ""
    
    private lazy var userProfileVC: UserProfileViewController = {
        let userProfileVC = UserProfileViewController(userId: userId)
        userProfileVC.delegate = self
        userProfileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        return userProfileVC
    }()
    
    init(navigationController: UINavigationController, currentUserPublisher: AnyPublisher<User?, Never>) {
        self.navigationController = navigationController
        self.currentUserPublisher = currentUserPublisher
        updateUser()
    }
    
    func start() {
        self.navigationController.pushViewController(self.userProfileVC, animated: true)
    }
    
    func updateUser() {
        currentUserPublisher
            .compactMap { $0 } 
            .sink { [weak self] user in
                self?.userId = user.id
            }.store(in: &subscriptons)
    }
    
}

extension UserProfileCoordinator: UserProfileViewControllerDelegate {
    func userProfileViewController(controller: UserProfileViewController, userLoggedOutSuccessfully withUser: String) {
        self.finish()
    }
    
}
