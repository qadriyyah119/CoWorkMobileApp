//
//  MapViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 9/21/22.
//

import UIKit

class MapViewModel {
    
    var workspaces: [Workspace] = []
    weak var datasource: WorkspaceDataSource?
    
    let searchTabTitle: String = "Search"
    let searchTabIcon = UIImage(systemName: "location.magnifyingglass")
    
    init(workspaces: [Workspace]) {
        self.workspaces = workspaces
    }
    
}
