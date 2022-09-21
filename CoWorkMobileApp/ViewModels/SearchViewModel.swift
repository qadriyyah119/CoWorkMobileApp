//
//  SearchViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit
import RealmSwift

class SearchViewModel {
    
    var workspaces: [Workspace] = []
    
    func getWorkspaceList() {
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
