//
//  WorkspaceDetailReviewCell.swift
//  CoWorkMobileApp
//


import UIKit

class WorkspaceDetailReviewCell: UICollectionViewCell {
    
    static let identifier = String(describing: WorkspaceDetailReviewCell.self) + "CellReuseIndentifier"
    
    var reviewId: String?
    weak var reviewDelegate: WorkspaceDetailReviewContentConfigurationDelegate?
    var workspaceDetailReviewContentConfiguration: WorkspaceDetailReviewContentConfiguration?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let reviewId = self.reviewId else { return }
        
        workspaceDetailReviewContentConfiguration = WorkspaceDetailReviewContentConfiguration(reviewId: reviewId)
        workspaceDetailReviewContentConfiguration?.delegate = reviewDelegate
        if let contentConfiguration = workspaceDetailReviewContentConfiguration {
            self.contentConfiguration = contentConfiguration
        }
    }
}
