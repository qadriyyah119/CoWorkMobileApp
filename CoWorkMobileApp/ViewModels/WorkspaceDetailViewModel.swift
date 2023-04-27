//
//  WorkspaceDetailViewModel.swift
//  CoWorkMobileApp
//


import UIKit

class WorkspaceDetailViewModel {
    
    var workspace: Workspace?
    var workspaceId: String
    var reviews: [WorkspaceReview]?
    
    init(workspaceId: String) {
        self.workspaceId = workspaceId
    }
    
    func getWorkspace(forId id: String, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        WorkspaceManager.shared.getWorkspaceDetails(withId: id) { result in
            group.leave()
            switch result {
            case .success(let workspace):
                self.workspace = workspace
            case .failure(let error):
                print(error)
            }
        }
        
        group.enter()
        
        WorkspaceManager.shared.getWorkspaceReviews(withId: id) { result in
            group.leave()
            switch result {
            case .success(let reviews):
                print("REVIEWS: \(reviews.count)")
                self.reviews = Array(reviews)
            case .failure(let error):
                print(error)
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
}
