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

class WorkspaceCoordinator: NSObject, Coordinator, WorkspaceDataSource {
    var workspaces: [Workspace] = []
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var locationManager = CLLocationManager()
    var workspaceDetailViewController: WorkspaceDetailViewController?
    
    private lazy var workspaceListVC: WorkspaceListViewController = {
        let viewController = WorkspaceListViewController()
        viewController.delegate = self
        viewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "location.magnifyingglass"), tag: 0)
        return viewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        self.navigationController.pushViewController(self.workspaceListVC, animated: true)
    }

}

extension WorkspaceCoordinator: WorkspaceListViewControllerDelegate {
    
    func workspaceListViewController(controller: WorkspaceListViewController, didSelectWorkspaceWithId id: String) {
        let workspaceDetailViewController = WorkspaceDetailViewController(workspaceId: id)
        workspaceDetailViewController.delegate = self
        self.workspaceDetailViewController = workspaceDetailViewController
        let navigationController = UINavigationController(rootViewController: workspaceDetailViewController)
        navigationController.modalPresentationStyle = .fullScreen
        controller.navigationController?.present(navigationController, animated: true)
    }
    
}

extension WorkspaceCoordinator: WorkspaceDetailViewControllerDelegate {
    func didSelectViewMoreButton(forReview id: String, sender: UIButton) {
        
        guard let presentingViewController = ((self.navigationController.topViewController?.presentedViewController as? UINavigationController)?.viewControllers.first?.presentedViewController as? UINavigationController)?.viewControllers.first else { return }
        
        let reviewDetailViewController = WorkspaceReviewPopoverViewController(reviewId: id)
        
        reviewDetailViewController.modalPresentationStyle = .popover
        reviewDetailViewController.popoverPresentationController?.sourceView = sender
        reviewDetailViewController.popoverPresentationController?.permittedArrowDirections = .up
        reviewDetailViewController.popoverPresentationController?.delegate = self
        presentingViewController.present(reviewDetailViewController, animated: true)
        
    }

}

extension WorkspaceCoordinator: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

