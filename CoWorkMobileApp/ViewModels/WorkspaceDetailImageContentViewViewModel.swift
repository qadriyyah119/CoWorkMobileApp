//
//  WorkspaceDetailImageContentViewViewModel.swift
//  CoWorkMobileApp
//


import UIKit
import RealmSwift

class WorkspaceDetailImageContentViewViewModel {
    
    var workspace: Workspace? {
        didSet {
            if let workspace = workspace {
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
    
    var workspaceImage: UIImage?
    var workspaceImageCompletion: ((UIImage?) -> Void)?
    
    func fill(withWorkspaceId id: String, completion: (() -> Void)? ) {
        let realm = try? Realm()
        self.workspace = realm?.object(ofType: Workspace.self, forPrimaryKey: id)
        completion?()
    }
}
