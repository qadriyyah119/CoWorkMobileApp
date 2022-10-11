//
//  NavigationRouter.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 10/11/22.
//

import UIKit

protocol NavigationRouter {
    func navigate(to viewController: UIViewController, with action: NavigationAction)
}

//extension NavigationRouter {
//    func navigate(to viewController: UIViewController, with action: NavigationAction) {
//        
//    }
//}
