//
//  WorkspaceListFilterCell.swift
//  CoWorkMobileApp
//


import UIKit

class WorkspaceListFilterCell: UICollectionViewCell {
    
    static let identifier = String(describing: WorkspaceListFilterCell.self) + "CellReuseIndentifier"
    
    var title: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let title = self.title else { return }
        
        let contentConfiguration = WorkspaceListFilterContentConfiguration(title: title)
        self.contentConfiguration = contentConfiguration
    }
}
