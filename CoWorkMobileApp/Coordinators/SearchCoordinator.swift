//
//  SearchCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 10/12/22.
//

import UIKit
import MapKit
import CoreLocation
import Combine

protocol WorkspaceDataSource: AnyObject {
    var workspaces: [Workspace] { get set }
}

class SearchCoordinator: Coordinator, WorkspaceDataSource {
    var workspaces: [Workspace] = []
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var locationManager = CLLocationManager()
    
    private lazy var workspaceListVC: WorkspaceListViewController = {
        let viewController = WorkspaceListViewController()
//        viewController.tabBarItem = UITabBarItem(title: workspaceListViewModel.searchTabTitle, image: workspaceListViewModel.searchTabIcon, tag: 0)
        return viewController
    }()
    
    private lazy var mapViewController: MapViewController = {
        let viewController = MapViewController()
        viewController.delegate = self
//        viewController.tabBarItem = UITabBarItem(title: mapViewModel.searchTabTitle, image: mapViewModel.searchTabIcon, tag: 0)
        return viewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        self.navigationController.pushViewController(self.mapViewController, animated: true)
        
    }
    
    private func presentModalView() {
        guard self.navigationController.presentedViewController == nil else { return }
        let workspaceListViewController = workspaceListVC
        
        let navController = UINavigationController(rootViewController: workspaceListViewController)
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

extension SearchCoordinator: MapViewControllerDelegate {
    func mapViewController(_ controller: MapViewController, userDidUpdateLocation location: CLLocation, query: String) {
        
        workspaceListVC.currentLocation = location
        workspaceListVC.searchQuery = query
        
        self.presentModalView()

    }

}

