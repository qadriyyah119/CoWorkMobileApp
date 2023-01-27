//
//  WorkspaceDetailImageCell.swift
//  CoWorkMobileApp
//


import UIKit

class WorkspaceDetailImageCell: UICollectionViewCell {
    
    static let identifier = String(describing: WorkspaceDetailImageCell.self) + "CellReuseIndentifier"
    
    var workspaceId: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let workspaceId = self.workspaceId else { return }
        
        let contentConfiguration = WorkspaceDetailImageContentConfiguration(workspaceId: workspaceId)
        self.contentConfiguration = contentConfiguration
    }
}
