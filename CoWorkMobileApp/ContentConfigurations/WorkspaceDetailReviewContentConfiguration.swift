//
//  WorkspaceDetailReviewsContentConfiguration.swift
//  CoWorkMobileApp
//


import UIKit

protocol WorkspaceDetailReviewContentConfigurationDelegate: AnyObject {
    
    func workspaceDetailReviewContentConfiguration(configuration: WorkspaceDetailReviewContentConfiguration,
                                                   didSelectViewMoreForReview id: String,
                                                   sender: UIButton)
}

public struct WorkspaceDetailReviewContentConfiguration: UIContentConfiguration {
    var reviewId: String?
    var delegate: WorkspaceDetailReviewContentConfigurationDelegate?
    
    public func makeContentView() -> UIView & UIContentView {
        let view = WorkspaceDetailReviewContentView(configuration: self)
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        view.layer.shadowColor = ThemeColors.secondaryColor?.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 5
        view.backgroundColor = ThemeColors.mainBackgroundColor
        
        view.didSelectViewMoreButton = { id, sender in
            guard let id = reviewId else { return }
            self.delegate?.workspaceDetailReviewContentConfiguration(configuration: self, didSelectViewMoreForReview: id, sender: sender)
        }
        
        return view
    }
    
    public func updated(for state: UIConfigurationState) -> WorkspaceDetailReviewContentConfiguration {
        return self
    }

}

extension WorkspaceDetailReviewContentConfiguration: Equatable {
    public static func ==(lhs: WorkspaceDetailReviewContentConfiguration, rhs: WorkspaceDetailReviewContentConfiguration) -> Bool {
        return lhs.reviewId == rhs.reviewId
    }
}

