//
//  WorkspaceListContentConfiguration.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit

public struct WorkspaceListContentConfiguration: UIContentConfiguration {
    var workspaceId: String?
    
    public func makeContentView() -> UIView & UIContentView {
        return WorkspaceListContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> WorkspaceListContentConfiguration {
        return self
    }

}

extension WorkspaceListContentConfiguration: Equatable {
    public static func ==(lhs: WorkspaceListContentConfiguration, rhs: WorkspaceListContentConfiguration) -> Bool {
        return lhs.workspaceId == rhs.workspaceId
    }
}

