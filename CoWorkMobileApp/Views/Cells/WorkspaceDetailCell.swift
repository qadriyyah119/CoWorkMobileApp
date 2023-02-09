//
//  WorkspaceDetailCell.swift
//  CoWorkMobileApp
//

import UIKit

class WorkspaceDetailCell: UICollectionViewCell {
    
    static let identifier = String(describing: WorkspaceDetailCell.self) + "CellReuseIndentifier"
    
    var workspaceId: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let workspaceId = self.workspaceId else { return }
        
        let contentConfiguration = WorkspaceDetailContentConfiguration(workspaceId: workspaceId)
        self.contentConfiguration = contentConfiguration
    }
}

