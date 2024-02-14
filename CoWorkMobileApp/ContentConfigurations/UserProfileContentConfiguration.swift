//
//  UserProfileContentConfiguration.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 1/30/24.
//

import UIKit

public struct UserProfileContentConfiguration: UIContentConfiguration {
    var userId: String?
    
    public func makeContentView() -> UIView & UIContentView {
        let view = UserProfileContentView(configuration: self)
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        view.layer.shadowColor = ThemeColors.secondaryColor?.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 5
        view.backgroundColor = ThemeColors.mainBackgroundColor
        
        return view
    }
    
    public func updated(for state: UIConfigurationState) -> UserProfileContentConfiguration {
        return self
    }

}

extension UserProfileContentConfiguration: Equatable {
    public static func ==(lhs: UserProfileContentConfiguration, rhs: UserProfileContentConfiguration) -> Bool {
        return lhs.userId == rhs.userId
    }
}
