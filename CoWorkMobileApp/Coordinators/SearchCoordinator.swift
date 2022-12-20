//
//  SearchCoordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 10/12/22.
//

import UIKit
import MapKit
import CoreLocation

protocol WorkspaceDataSource: AnyObject {
    var workspaces: [Workspace] { get set }
}

class SearchCoordinator: Coordinator, WorkspaceDataSource {
    var workspaces: [Workspace] = []
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private lazy var workspaceListVC: WorkspaceListViewController = {
        let workspaceListViewModel = WorkspaceListViewModel(workspaces: workspaces)
        let viewController = WorkspaceListViewController(viewModel: workspaceListViewModel)
        viewController.tabBarItem = UITabBarItem(title: workspaceListViewModel.searchTabTitle, image: workspaceListViewModel.searchTabIcon, tag: 0)
        return viewController
    }()
    
    private lazy var mapViewController: MapViewController = {
        let mapViewModel = MapViewModel(workspaces: workspaces)
        let viewController = MapViewController(viewModel: mapViewModel)
        viewController.delegate = self
        viewController.tabBarItem = UITabBarItem(title: mapViewModel.searchTabTitle, image: mapViewModel.searchTabIcon, tag: 0)
        return viewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        LocationHelper.shared.startLocationService()
        self.getWorkspaces {
            self.navigationController.pushViewController(self.mapViewController, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.presentModalView()
        }
        
    }
    
    private func presentModalView() {
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

    func getWorkspaces(completion: @escaping () -> Void) {
            WorkspaceManager.shared.getWorkspaces { result in
                switch result {
                case .success(let workspaces):
                    self.workspaces = Array(workspaces)
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
}

extension SearchCoordinator: MapViewControllerDelegate {
    func mapViewController(_ controller: MapViewController, userDidUpdateLocation location: CLLocation) {
        
    }
    
}
