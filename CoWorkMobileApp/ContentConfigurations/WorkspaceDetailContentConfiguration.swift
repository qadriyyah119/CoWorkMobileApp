//
//  WorkspaceDetailContentConfiguration.swift
//  CoWorkMobileApp
//

import UIKit

public struct WorkspaceDetailContentConfiguration: UIContentConfiguration {
    var workspaceId: String?
    
    public func makeContentView() -> UIView & UIContentView {
        return WorkspaceDetailContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> WorkspaceDetailContentConfiguration {
        return self
    }

}

extension WorkspaceDetailContentConfiguration: Equatable {
    public static func ==(lhs: WorkspaceDetailContentConfiguration, rhs: WorkspaceDetailContentConfiguration) -> Bool {
        return lhs.workspaceId == rhs.workspaceId
    }
}
