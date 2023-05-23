//
//  WorkspaceDetailReviewsContentConfiguration.swift
//  CoWorkMobileApp
//


import UIKit

public struct WorkspaceDetailReviewContentConfiguration: UIContentConfiguration {
    var workspaceId: String?
    
    public func makeContentView() -> UIView & UIContentView {
        return WorkspaceDetailReviewsContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> WorkspaceDetailReviewContentConfiguration {
        return self
    }

}

extension WorkspaceDetailReviewContentConfiguration: Equatable {
    public static func ==(lhs: WorkspaceDetailReviewContentConfiguration, rhs: WorkspaceDetailReviewContentConfiguration) -> Bool {
        return lhs.workspaceId == rhs.workspaceId
    }
}

