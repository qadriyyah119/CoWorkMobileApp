//
//  RootTabBarCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 2/13/24.
//

import UIKit
import Combine

enum TabBarPage {
    
    case workspace
    case collections
    case userProfile
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .workspace
        case 1:
            self = .collections
        case 2:
            self = .userProfile
        default:
            return nil
        }
    }
    
    func pageTitle() -> String {
        switch self {
        case .workspace:
            return "Search"
        case .collections:
            return "Collections"
        case .userProfile:
            return "Profile"
        }
    }
    
    func pageIcon() -> UIImage {
        switch self {
        case .workspace:
            return UIImage(systemName: "location.magnifyingglass")!
        case .collections:
            return UIImage(systemName: "bookmark.fill")!
        case .userProfile:
            return UIImage(systemName: "person.fill")!
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .workspace:
            return 0
        case .collections:
            return 1
        case .userProfile:
            return 2
        }
    }
}

class RootTabBarCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var type: CoordinatorType { .rootTabBar }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var parentCoordinator: AppCoordinator?
    var currentUser: User?
    var currentUserPublisher: AnyPublisher<User?, Never>
    var subscriptons = Set<AnyCancellable>()
    
    required init(navigationController: UINavigationController, currentUserPublisher: AnyPublisher<User?, Never>) {
        self.navigationController = navigationController
        self.currentUserPublisher = currentUserPublisher
        self.tabBarController = .init()
    }
    
    func start() {
        subscribeToCurrentUser()
        
        let pages: [TabBarPage] = [.workspace, .collections, .userProfile].sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        setupTabBarController(withTabControllers: controllers)
        
    }
    
    func subscribeToCurrentUser() {
        currentUserPublisher.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &subscriptons)
    }
    
//    func subscribeToCurrentUser() {
//        self.parentCoordinator?.currentUserPublisher.sink { [weak self] user in
//            self?.currentUser = user
//        }.store(in: &subscriptons)
//    }
    
    private func setupTabBarController(withTabControllers tabControllers: [UIViewController]) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ThemeColors.mainBackgroundColor
        self.tabBarController.tabBar.standardAppearance = appearance
        self.tabBarController.tabBar.scrollEdgeAppearance = appearance
        self.tabBarController.tabBar.tintColor = ThemeColors.tintColor
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.workspace.pageOrderNumber()
        tabBarController.tabBar.isTranslucent = false 
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.tabBarItem = UITabBarItem(title: page.pageTitle(), image: page.pageIcon(), tag: page.pageOrderNumber())
        
        switch page {
        case .workspace:
            let workspaceCoordinator = WorkspaceCoordinator(navigationController: UINavigationController())
            childCoordinators.append(workspaceCoordinator)
            workspaceCoordinator.start()
            return workspaceCoordinator.navigationController
        case .collections:
            let collectionsVC = CollectionsViewController()
            navController.pushViewController(collectionsVC, animated: true)
        case .userProfile:
            let userProfileCoordinator = UserProfileCoordinator(navigationController: UINavigationController(), currentUserPublisher: currentUserPublisher)
            userProfileCoordinator.parentCoordinator = self
            childCoordinators.append(userProfileCoordinator)
            userProfileCoordinator.start()
            return userProfileCoordinator.navigationController
        }
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}

extension RootTabBarCoordinator: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        <#code#>
//    }
}
