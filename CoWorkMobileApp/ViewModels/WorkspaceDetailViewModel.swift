//
//  WorkspaceDetailViewModel.swift
//  CoWorkMobileApp
//


import UIKit

class WorkspaceDetailViewModel {
    
    var workspace: Workspace?
    var workspaceId: String
    
    init(workspaceId: String) {
        self.workspaceId = workspaceId
    }
    
    func getWorkspaceDetails(forId id: String, completion: @escaping () -> Void) {
        WorkspaceManager.shared.getWorkspaceDetails(withId: id) { result in
            switch result {
            case .success(let workspace):
                print("Details: \(workspace)")
                self.workspace = workspace
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
    
}
