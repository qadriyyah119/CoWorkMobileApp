//
//  WorkspaceListFilterContentConfiguration.swift
//  CoWorkMobileApp
//


import UIKit

public struct WorkspaceListFilterContentConfiguration: UIContentConfiguration {
    var title: String?
    
    public func makeContentView() -> UIView & UIContentView {
        return WorkspaceListFilterContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> WorkspaceListFilterContentConfiguration {
        return self
    }

}

extension WorkspaceListFilterContentConfiguration: Equatable {
    public static func ==(lhs: WorkspaceListFilterContentConfiguration, rhs: WorkspaceListFilterContentConfiguration) -> Bool {
        return lhs.title == rhs.title
    }
}
