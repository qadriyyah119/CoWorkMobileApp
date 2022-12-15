//
//  WorkspaceListViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit
import RealmSwift

class WorkspaceListViewModel {
    
    var workspaces: [Workspace] = []
    weak var datasource: WorkspaceDataSource?
    
    let searchTabTitle: String = "Search"
    let searchTabIcon = UIImage(systemName: "location.magnifyingglass")
    
    init(workspaces: [Workspace]) {
        self.workspaces = workspaces
    }
    
}
