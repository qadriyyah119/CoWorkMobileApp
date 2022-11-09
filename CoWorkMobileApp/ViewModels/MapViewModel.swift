//
//  MapViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 9/21/22.
//

import UIKit

class MapViewModel {
    
    var workspaces: [Workspace] = []
    
    let searchTabTitle: String = "Search"
    let searchTabIcon = UIImage(systemName: "location.magnifyingglass")
    
    func getWorkspaces() {
        WorkspaceManager.shared.getWorkspaces { result in
            switch result {
            case .success(let workspaces):
                print("Success!")
                self.workspaces = Array(workspaces)
            case .failure(let error):
                print(error)
            }
        }
    }
}