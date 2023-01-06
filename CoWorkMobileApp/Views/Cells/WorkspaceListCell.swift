//
//  WorkspaceListCell.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/15/22.
//

import UIKit

class WorkspaceListCell: UICollectionViewCell {
    
    static let identifier = String(describing: WorkspaceListCell.self) + "CellReuseIndentifier"
    
    var workspaceId: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let workspaceId = self.workspaceId else { return }
        
        let contentConfiguration = WorkspaceListContentConfiguration(workspaceId: workspaceId)
        self.contentConfiguration = contentConfiguration
    }
}
