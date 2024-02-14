//
//  RootTabBarController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/10/22.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let viewModel: RootTabBarViewModel
    
    init(viewModel: RootTabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workspaceCoordinator.start()
        self.setupView()
    }
    
    private func setupView() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ThemeColors.mainBackgroundColor
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        self.tabBar.tintColor = ThemeColors.tintColor
        self.setViewControllers([workspaceCoordinator.navigationController, collectionsVC, userProfileCoordinator.navigationController], animated: false)
        self.delegate = self
    }
    
    let workspaceCoordinator: WorkspaceCoordinator = {
        let workspaceCoordinator = WorkspaceCoordinator(navigationController: UINavigationController())
        workspaceCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "location.magnifyingglass"), tag: 0)
        return workspaceCoordinator
    }()
    
    let userProfileCoordinator: UserProfileCoordinator = {
        let userProfileCoordinator = UserProfileCoordinator(navigationController: UINavigationController())
        userProfileCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        return userProfileCoordinator
    }()
    
    private lazy var collectionsVC: UINavigationController = {
        let viewController = CollectionsViewController()
        viewController.tabBarItem = UITabBarItem(title: viewModel.collectionsTabTitle, image: viewModel.collectionsTabIcon, tag: 1)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()
    
//    private lazy var profileVC: UINavigationController = {
//        let viewController = UserProfileViewController()
//        viewController.tabBarItem = UITabBarItem(title: viewModel.profileTabTitle, image: viewModel.profileTabIcon, tag: 2)
//        let navigationController = UINavigationController(rootViewController: viewController)
//        return navigationController
//    }()

}
