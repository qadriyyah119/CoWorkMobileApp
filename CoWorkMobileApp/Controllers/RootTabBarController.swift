//
//  RootTabBarController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/10/22.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let viewModel = RootTabBarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        let appearance = UITabBarAppearance()
        self.tabBar.standardAppearance = appearance
        self.tabBar.tintColor = ThemeColors.tintColor
        self.setViewControllers([searchVC, collectionsVC, profileVC], animated: false)
        self.delegate = self
    }
    
    private lazy var searchVC: UINavigationController = {
        let viewController = SearchViewController()
        viewController.tabBarItem = UITabBarItem(title: viewModel.searchTabTitle, image: viewModel.searchTabIcon, tag: 0)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()
    
    private lazy var collectionsVC: UINavigationController = {
        let viewController = CollectionsViewController()
        viewController.tabBarItem = UITabBarItem(title: viewModel.collectionsTabTitle, image: viewModel.collectionsTabIcon, tag: 1)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()
    
    private lazy var profileVC: UINavigationController = {
        let viewController = UserProfileViewController()
        viewController.tabBarItem = UITabBarItem(title: viewModel.profileTabTitle, image: viewModel.profileTabIcon, tag: 2)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()

}
