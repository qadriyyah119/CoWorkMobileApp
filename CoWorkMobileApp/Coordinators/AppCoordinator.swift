//
//  AppCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 10/11/22.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private lazy var welcomeViewController: WelcomeViewController = {
        let welcomeViewModel = WelcomeViewModel()
        welcomeViewModel.coordinator = self
        let viewController = WelcomeViewController(viewModel: welcomeViewModel)
        return viewController
    }()
    
    private lazy var rootTabBarController: RootTabBarController = {
        let rootTabBarViewModel = RootTabBarViewModel()
        let viewController = RootTabBarController(viewModel: rootTabBarViewModel)
        return viewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showWelcomeView()
    }
    
    func showWelcomeView() {
        self.navigationController.pushViewController(welcomeViewController, animated: true)
    }
    
    func showLoginView() {
        let loginViewModel = LoginViewModel()
        loginViewModel.coordinator = self 
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func showRegistrationView() {
        let registrationViewModel = AccountRegistrationViewModel()
        let registrationViewController = AccountRegistrationViewController(viewModel: registrationViewModel)
        self.navigationController.pushViewController(registrationViewController, animated: true)
    }
    
    func showMainFlow() {
        self.setupTabBarContentView()
    }
    
    func setupTabBarContentView() {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(toNewView: rootTabBarController)
    }
    
}

