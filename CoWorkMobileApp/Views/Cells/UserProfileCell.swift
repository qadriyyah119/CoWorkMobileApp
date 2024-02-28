//
//  UserProfileCell.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 1/30/24.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    static let identifier = String(describing: UserProfileCell.self) + "CellReuseIndentifier"
    
    var userId: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let userId = self.userId else { return }
        
        let contentConfiguration = UserProfileContentConfiguration(userId: userId)
        self.contentConfiguration = contentConfiguration
    }
}
