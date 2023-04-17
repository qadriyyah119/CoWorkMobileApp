//
//  WorkspaceCoordinator.swift
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

class WorkspaceCoordinator: Coordinator, WorkspaceDataSource {
    var workspaces: [Workspace] = []
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var locationManager = CLLocationManager()
    var workspaceDetailViewController: WorkspaceDetailViewController?
    
    private lazy var workspaceListVC: WorkspaceListViewController = {
        let viewController = WorkspaceListViewController()
        viewController.delegate = self
//        viewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "location.magnifyingglass"), tag: 0)
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
        
        let navController = UINavigationController(rootViewController: workspaceListVC)
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
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        
        self.navigationController.present(navController, animated: true)
//        var tabBarController = self.navigationController.viewControllers.first?.tabBarController
//        tabBarController?.tabBar.bringSubviewToFront((navController.topViewController?.view)!)
    }

}

extension WorkspaceCoordinator: MapViewControllerDelegate {
    func mapViewController(_ controller: MapViewController, userDidUpdateLocation location: CLLocation, query: String) {
        
        workspaceListVC.currentLocation = location
        workspaceListVC.searchQuery = query
        
        self.presentModalView()

    }

}

extension WorkspaceCoordinator: WorkspaceListViewControllerDelegate {
    func workspaceListViewController(controller: WorkspaceListViewController, didSelectWorkspaceWithId id: String) {
        let workspaceDetailViewController = WorkspaceDetailViewController(workspaceId: id)
        self.workspaceDetailViewController = workspaceDetailViewController
        let navigationController = UINavigationController(rootViewController: workspaceDetailViewController)
        navigationController.modalPresentationStyle = .fullScreen
        controller.navigationController?.present(navigationController, animated: true)
    }
    
}

