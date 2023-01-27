//
//  WorkspaceListContentView.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit
import Cartography
import RealmSwift

class WorkspaceListContentView: UIView, UIContentView {
    
    private var viewModel = WorkspaceListContentViewViewModel()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
//    private let imageCard: UIView = {
//        let cardView = UIView()
//        cardView.layer.cornerRadius = 8
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        return cardView
//    }()
    
    private(set) lazy var spaceImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(bookmarkButton)
        
        constrain(bookmarkButton) { bookmarkButton in
            bookmarkButton.trailing == bookmarkButton.superview!.trailing - 16
            bookmarkButton.top == bookmarkButton.superview!.top + 16
        }
        return imageView
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark.circle"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 16)
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 14)
        return label
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            distanceLabel
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var ratingStar: UIImageView = {
        let imageSize = UIFont.systemFont(ofSize: 14)
        let config = UIImage.SymbolConfiguration(font: imageSize)
        let image = UIImage(systemName: "star.fill", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 14)
        return label
    }()
    
    private lazy var reviewCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 14)
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            ratingStar,
            ratingLabel,
            reviewCountLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentConfiguration: WorkspaceListContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        } set {
            guard let newConfiguration = newValue as? WorkspaceListContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: WorkspaceListContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(configuration: WorkspaceListContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        self.currentConfiguration = configuration
        
        guard let workspaceId = currentConfiguration.workspaceId else { return }
        viewModel.workspaceImageCompletion = { image in
            self.spaceImageView.image = image
        }
        viewModel.fill(withWorkspaceId: workspaceId) {
            self.populateView()
        }
    }
    
    private func populateView() {
        spaceImageView.image = viewModel.workspaceImage
        nameLabel.text = viewModel.nameText
        distanceLabel.text = viewModel.distanceText
        ratingLabel.text = viewModel.ratingText
        reviewCountLabel.text = viewModel.reviewCountText
    }
    
    private func setupView() {
        addSubview(contentView)
        [spaceImageView, nameStackView, ratingStackView].forEach { self.contentView.addSubview($0)}
        
        constrain(contentView, spaceImageView, nameStackView, ratingStackView) { contentView, spaceImageView, nameStackView, ratingStackView in
            contentView.edges == contentView.superview!.edges
            spaceImageView.top == spaceImageView.superview!.top
            spaceImageView.leading == spaceImageView.superview!.leading + 4
            spaceImageView.trailing == spaceImageView.superview!.trailing - 4
            spaceImageView.bottom == nameStackView.top - 16
            nameStackView.leading == nameStackView.superview!.leading + 8
            nameStackView.bottom == nameStackView.superview!.bottom
            ratingStackView.trailing == ratingStackView.superview!.trailing - 8
            ratingStackView.top == nameStackView.top
            
        }
    }
}
