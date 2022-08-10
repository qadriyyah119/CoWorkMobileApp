//
//  RootTabBarViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/10/22.
//

import UIKit

class RootTabBarViewModel {
    
    enum TabBarTypeStrings {
        static let search = "Search"
        static let collections = "Collections"
        static let profile = "Profile"
    }
    
    let searchTabTitle: String = TabBarTypeStrings.search
    let collectionsTabTitle: String = TabBarTypeStrings.collections
    let profileTabTitle: String = TabBarTypeStrings.profile
    let searchTabIcon = UIImage(systemName: "location.magnifyingglass")
    let collectionsTabIcon = UIImage(systemName: "bookmark.fill")
    let profileTabIcon = UIImage(systemName: "person.fill")
}
