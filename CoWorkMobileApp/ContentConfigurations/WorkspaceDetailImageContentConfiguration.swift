//
//  WorkspaceDetailImageContentConfiguration.swift
//  CoWorkMobileApp
//


import UIKit

public struct WorkspaceDetailImageContentConfiguration: UIContentConfiguration {
    var workspaceId: String?
    
    public func makeContentView() -> UIView & UIContentView {
        return WorkspaceDetailImageContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> WorkspaceDetailImageContentConfiguration {
        return self 
    }

}

extension WorkspaceDetailImageContentConfiguration: Equatable {
    public static func ==(lhs: WorkspaceDetailImageContentConfiguration, rhs: WorkspaceDetailImageContentConfiguration) -> Bool {
        return lhs.workspaceId == rhs.workspaceId
    }
}
