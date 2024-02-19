//
//  AppCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 10/11/22.
//

import UIKit
import RealmSwift
import Combine

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorType { .app }
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var currentUser: User?
    private let currentUserPublisher = CurrentValueSubject<User?, Never>(nil)
    
    var currentUserUpdates: AnyPublisher<User?, Never> {
        return currentUserPublisher.eraseToAnyPublisher()
    }
    
    
    private lazy var welcomeViewController: WelcomeViewController = {
        let welcomeViewModel = WelcomeViewModel()
        welcomeViewModel.coordinator = self
        let viewController = WelcomeViewController(viewModel: welcomeViewModel)
        return viewController
    }()
    
//    private lazy var rootTabBarController: RootTabBarController = {
//        let rootTabBarViewModel = RootTabBarViewModel()
//        let viewController = RootTabBarController(viewModel: rootTabBarViewModel)
//        return viewController
//    }()
    
    private lazy var rootTabBarCoordinator: RootTabBarCoordinator = {
        let coordinator = RootTabBarCoordinator(navigationController: navigationController, currentUserPublisher: currentUserUpdates)
        return coordinator
    }()
    
    let workspaceCoordinator = WorkspaceCoordinator(navigationController: UINavigationController())
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if let currentUser = getCurrentUser() {
            self.currentUser = currentUser
            print("CURRENT USER SET \(currentUser)")
            updateUser(currentUser)
            showMainFlow()
        } else {
            showWelcomeView()
        }
        
    }
    
    func updateUser(_ user: User) {
        currentUserPublisher.send(user)
    }
    
    func getCurrentUser() -> User? {
        guard let id = UserDefaults.standard.string(forKey: "currentUserId") else { return nil }
        
        let realm = try? Realm()
        let user = realm?.object(ofType: User.self, forPrimaryKey: id)
        return user
    }
    
    func showWelcomeView() {
        self.navigationController.pushViewController(welcomeViewController, animated: true)
    }
    
    func showLoginView() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.finishDelegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()

    }
    
    func showRegistrationView() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.finishDelegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showMainFlow(withSuccessBanner showBanner: Bool = false) {
//        self.setupTabBarContentView()
//        workspaceCoordinator.start()
        let rootTabBarCoordinator = RootTabBarCoordinator(navigationController: navigationController, currentUserPublisher: currentUserUpdates)
        rootTabBarCoordinator.parentCoordinator = self
        childCoordinators.append(rootTabBarCoordinator)
        rootTabBarCoordinator.start()
       
        if showBanner {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Banner.showBanner(withTitle: "Success!", subtitle: "Welcome! You have successfull registered with CoWork!", style: .success)
            }
        }
    }
    
//    func setupTabBarContentView() {
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(toNewView: rootTabBarController)
//    }
    
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .auth:
            navigationController.viewControllers.removeAll()
            showMainFlow(withSuccessBanner: false)
        case .onboarding:
            navigationController.viewControllers.removeAll()
            showMainFlow(withSuccessBanner: true)
        default:
            break
        }
    }
}
