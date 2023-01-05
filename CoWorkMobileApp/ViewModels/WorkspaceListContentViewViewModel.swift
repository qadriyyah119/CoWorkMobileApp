//
//  WorkspaceListContentViewViewModel.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/23/22.
//

import UIKit
import RealmSwift

class WorkspaceListContentViewViewModel {
    
    var workspace: Workspace? {
        didSet {
            if let workspace = workspace {
                nameText = workspace.name
                distanceText = "\(workspace.distance ?? 0.0)"
                ratingText = "\(workspace.rating ?? 0.0)"
                reviewCountText = "(\(workspace.reviewCount ?? 0))"
                
                if let imageUrl = workspace.imageUrl {
                    WorkspaceManager.shared.fetchImage(from: imageUrl) { result in
                        switch result {
                        case .failure(let error):
                            print("Photo Failure: \(error)")
                        case .success(let image):
                            DispatchQueue.main.async {
                                self.workspaceImageCompletion?(image)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var nameText: String?
    var distanceText: String?
    var ratingText: String?
    var reviewCountText: String?
    var workspaceImage: UIImage?
    var workspaceImageCompletion: ((UIImage?) -> Void)?
    
    func fill(withWorkspaceId id: String, completion: (() -> Void)? ) {
        let realm = try? Realm()
        self.workspace = realm?.object(ofType: Workspace.self, forPrimaryKey: id)
        completion?()
    }
    
}
