//
//  SearchCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 10/12/22.
//

import UIKit

class SearchCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private lazy var searchVC: SearchViewController = {
        let searchViewModel = SearchViewModel()
        let viewController = SearchViewController(viewModel: searchViewModel)
        viewController.tabBarItem = UITabBarItem(title: searchViewModel.searchTabTitle, image: searchViewModel.searchTabIcon, tag: 0)
        return viewController
    }()
    
    private lazy var mapViewController: MapViewController = {
        let viewController = MapViewController()
        return viewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Search Coordinator Start")
        self.navigationController.pushViewController(mapViewController, animated: true)
    }
    
}
