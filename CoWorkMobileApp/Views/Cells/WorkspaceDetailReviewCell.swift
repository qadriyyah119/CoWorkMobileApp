//
//  WorkspaceDetailReviewCell.swift
//  CoWorkMobileApp
//


import UIKit

class WorkspaceDetailReviewCell: UICollectionViewCell {
    
    static let identifier = String(describing: WorkspaceDetailReviewCell.self) + "CellReuseIndentifier"
    
    var reviewId: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let reviewId = self.reviewId else { return }
        
        let contentConfiguration = WorkspaceDetailReviewContentConfiguration(reviewId: reviewId)
        self.contentConfiguration = contentConfiguration
    }
}
