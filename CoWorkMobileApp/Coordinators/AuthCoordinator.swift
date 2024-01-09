//
//  AuthCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 1/9/24.
//

import UIKit

class AuthCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType { .auth }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    private lazy var loginViewController: LoginViewController = {
        let loginViewModel = LoginViewModel()
        let loginVC = LoginViewController(viewModel: loginViewModel)
        loginVC.delegate = self
        return loginVC
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
    
}

extension AuthCoordinator: LoginViewControllerDelegate {
    func loginViewController(controller: LoginViewController, didLoginSuccessfully withUser: String) {
        self.finish()
    }
    
}

