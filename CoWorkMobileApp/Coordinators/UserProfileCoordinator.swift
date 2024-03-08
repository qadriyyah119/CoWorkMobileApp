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
    var userSubscriptions = Set<AnyCancellable>()
    var currentUser: User?
    
    private lazy var userProfileVC: UserProfileViewController = {
        let userProfileViewModel = UserProfileViewModel(currentUserPublisher: currentUserPublisher)
        let userProfileVC = UserProfileViewController(viewModel: userProfileViewModel)
        userProfileVC.delegate = self
        userProfileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        return userProfileVC
    }()
    
    private lazy var userProfileSignInRegisterViewController: UserProfileSignInRegisterViewController = {
        let userProfileSignInRegisterViewModel = UserProfileSiginRegisterViewModel()
        let userProfileSiginRegisterVC = UserProfileSignInRegisterViewController(viewModel: userProfileSignInRegisterViewModel)
        userProfileSiginRegisterVC.delegate = self
        userProfileSiginRegisterVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        return userProfileSiginRegisterVC
    }()
    
    init(navigationController: UINavigationController, currentUserPublisher: AnyPublisher<User?, Never>) {
        self.navigationController = navigationController
        self.currentUserPublisher = currentUserPublisher
    }
    
    func start() {
        subscribeToCurrentUser()
        
        if self.currentUser == nil {
            self.navigationController.pushViewController(userProfileSignInRegisterViewController, animated: true)
        } else {
            self.navigationController.pushViewController(self.userProfileVC, animated: true)
        }
       
    }
    
    func subscribeToCurrentUser() {
        currentUserPublisher.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &userSubscriptions)
    }
    
}

extension UserProfileCoordinator: UserProfileViewControllerDelegate {
    func userProfileViewController(controller: UserProfileViewController, userLoggedOutSuccessfully userId: String) {
        self.finish()
    }
    
    func userProfileViewController(controller: UserProfileViewController, userTappedDeleteAccountButton userId: String) {
        
        let viewModel = DeleteAccountViewModel(userId: userId)
        let viewController = DeleteAccountModalViewController(viewModel: viewModel)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isToolbarHidden = true
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.isModalInPresentation = true
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 50
        }
        self.navigationController.present(navigationController, animated: true)
    }
    
}

extension UserProfileCoordinator: UserProfileSignInRegisterViewControllerDelegate {
    func userProfileSignInRegisterViewController(didSelectRegisterFromController: UserProfileSignInRegisterViewController) {
        parentCoordinator?.parentCoordinator?.showRegistrationView()
    }
    
    func userProfileSignInRegisterViewController(didSelectSignInFromController: UserProfileSignInRegisterViewController) {
        parentCoordinator?.parentCoordinator?.showLoginView()
    }
    
    
}

extension UserProfileCoordinator: DeleteAccountModalViewControllerDelegate {
    func deleteAccountModalViewController(controller: DeleteAccountModalViewController, userDeletedAccountSuccessfully withUser: String) {
        self.finish()
    }
}
