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
        return UserProfileContentView(configuration: self)
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
