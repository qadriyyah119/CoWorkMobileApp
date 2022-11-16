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
        return viewController
    }()
    
    private lazy var mapViewController: MapViewController = {
        let mapViewModel = MapViewModel()
        let viewController = MapViewController(viewModel: mapViewModel)
        viewController.tabBarItem = UITabBarItem(title: mapViewModel.searchTabTitle, image: mapViewModel.searchTabIcon, tag: 0)
        return viewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Search Coordinator Start")
        self.navigationController.pushViewController(mapViewController, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.presentModalView()
        }
        
    }
    
    private func presentModalView() {
        let searchViewController = searchVC
        
        let navController = UINavigationController(rootViewController: searchViewController)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = true
        
        let smallId = UISheetPresentationController.Detent.Identifier("small")
        
        if let sheet = navController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallId) { context in
                    return 80
                }
                sheet.detents = [smallDetent, .medium(), .large()]
            } else {
                sheet.detents = [.medium(), .large()]
            }
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        
        self.navigationController.present(navController, animated: true)
    }
    
}
