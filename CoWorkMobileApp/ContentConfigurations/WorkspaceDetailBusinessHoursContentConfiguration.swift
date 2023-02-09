//
//  WorkspaceDetailBusinessHoursContentConfiguration.swift
//  CoWorkMobileApp
//

import UIKit

public struct WorkspaceDetailBusinessHoursContentConfiguration: UIContentConfiguration {
    var workspaceId: String?
    
    public func makeContentView() -> UIView & UIContentView {
        return WorkspaceDetailBusinessHoursContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> WorkspaceDetailBusinessHoursContentConfiguration {
        return self
    }

}

extension WorkspaceDetailBusinessHoursContentConfiguration: Equatable {
    public static func ==(lhs: WorkspaceDetailBusinessHoursContentConfiguration, rhs: WorkspaceDetailBusinessHoursContentConfiguration) -> Bool {
        return lhs.workspaceId == rhs.workspaceId
    }
}
