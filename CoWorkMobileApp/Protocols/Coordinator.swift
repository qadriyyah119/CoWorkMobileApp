//
//  Coordinator.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 10/11/22.
//

import Foundation

protocol Coordinator {
    var navigationController: UINavigationController
    
    func start()
}

extension Coordinator: NavigationRouter {
    
}
