//
//  OnboardingCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 1/9/24.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType { .onboarding }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    private lazy var accountRegistrationViewController: AccountRegistrationViewController = {
        let accountRegistrationViewModel = AccountRegistrationViewModel()
        let accountRegistrationVC = AccountRegistrationViewController(viewModel: accountRegistrationViewModel)
        accountRegistrationVC.delegate = self
        return accountRegistrationVC
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.pushViewController(accountRegistrationViewController, animated: true)
    }
    
}

extension OnboardingCoordinator: AccountRegistrationViewControllerDelegate {
    func accountRegistrationViewController(controller: AccountRegistrationViewController, didRegisterSuccessfully withUser: String) {
        self.finish()

    }
    
}

