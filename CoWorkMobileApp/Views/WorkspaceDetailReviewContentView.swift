//
//  WorkspaceDetailReviewsContentView.swift
//  CoWorkMobileApp
//

import UIKit
import Cartography

class WorkspaceDetailReviewContentView: UIView, UIContentView {
    
    private var viewModel = WorkspaceDetailReviewContentViewViewModel()
    var didSelectViewMoreButton: ((_ reviewId: String) -> Void)?
    
    private lazy var userProfileImage: CircularImageView = {
       return CircularImageView(radius: 50)
    }()
    
    private lazy var userProfileNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyBoldFont, size: 14)
        return label
    }()
    
    private lazy var reviewDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 14)
        return label
    }()
    
    private lazy var nameDateVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userProfileNameLabel,
            reviewDateLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 14)
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var userProfileHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userProfileImage,
            nameDateVerticalStackView
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var viewMoreButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .small
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let button = UIButton()
        button.setAttributedTitle(viewModel.viewMoreText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.addTarget(self,
                         action: #selector(didTapViewMore),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var reviewVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userProfileHorizontalStackView,
            reviewLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private var currentConfiguration: WorkspaceDetailReviewContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        } set {
            guard let newConfiguration = newValue as? WorkspaceDetailReviewContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: WorkspaceDetailReviewContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapViewMore() {
        print("View more tapped")
        guard let reviewId = viewModel.workspaceReview?.id else { return }
        self.didSelectViewMoreButton?(reviewId)
    }
    
    private func apply(configuration: WorkspaceDetailReviewContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        self.currentConfiguration = configuration
        
        guard let reviewId = currentConfiguration.reviewId else { return }
        viewModel.userImageCompletion = { image in
            self.userProfileImage.image = image
        }

        viewModel.fill(withReviewId: reviewId) {
            self.populateView()
        }
    }
    
    private func populateView() {
        userProfileNameLabel.text = viewModel.userNameText
        reviewLabel.text = viewModel.reviewText
        reviewDateLabel.text = viewModel.reviewDateText
    }
    
    private func setupView() {
        self.addSubview(reviewVerticalStackView)
        self.addSubview(viewMoreButton)
        
        constrain(reviewVerticalStackView, viewMoreButton) { reviewVerticalStackView, viewMoreButton in
            reviewVerticalStackView.top == reviewVerticalStackView.superview!.top + 12
            reviewVerticalStackView.leading == reviewVerticalStackView.superview!.leading + 16
            reviewVerticalStackView.trailing == reviewVerticalStackView.superview!.trailing - 16
            viewMoreButton.top == reviewVerticalStackView.bottom + 12
            viewMoreButton.leading == viewMoreButton.superview!.leading + 12
            viewMoreButton.bottom == viewMoreButton.superview!.bottom - 12
        }
    }
}



