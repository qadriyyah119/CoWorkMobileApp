//
//  Coordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 10/11/22.
//

import UIKit

// MARK: - Coordinator Output
/// Delegate protocol helping parent Coordinator to know when it's child is ready to be finished/deallocated
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

// MARK: Coordinator

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start() 
}

