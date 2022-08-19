//
//  SearchContentView.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/11/22.
//

import UIKit
import Cartography
import RealmSwift

class SearchContentView: UIView, UIContentView {
    
    private(set) var workspace: Workspace? {
        didSet {
            if let workspace = workspace {
                nameLabel.text = workspace.name
                distanceLabel.text = "\(workspace.distance ?? 100)"
                ratingLabel.text = "\(workspace.rating ?? 4.0)"
                reviewCountLabel.text = "\((workspace.reviewCount) ?? 105)"
            }
        }
    }
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private let imageCard: UIView = {
        let cardView = UIView()
        cardView.layer.cornerRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private(set) lazy var spaceImageView: UIImageView = {
        let imageView = UIImageView()
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
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
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
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
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
        label.font = UIFont(name: ThemeFonts.bodyFontThin, size: 14)
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            ratingLabel,
            reviewCountLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
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
    
    private var currentConfiguration: SearchContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? SearchContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: SearchContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(configuration: SearchContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        self.currentConfiguration = configuration
        
        guard let workspaceId = currentConfiguration.workspaceId else { return }
        self.fill(withWorkspaceId: workspaceId)
    }
    
    private func fill(withWorkspaceId id: String) {
        let realm = try? Realm()
        self.workspace = realm?.object(ofType: Workspace.self, forPrimaryKey: id)
    }
    
    private func setupView() {
        addSubview(contentView)
        [spaceImageView, nameStackView, ratingStackView].forEach { self.contentView.addSubview($0)}
        
        constrain(contentView, spaceImageView, nameStackView, ratingStackView) { contentView, spaceImageView, nameStackView, ratingStackView in
            contentView.edges == contentView.superview!.edges
            spaceImageView.top == spaceImageView.superview!.top
            spaceImageView.leading == spaceImageView.superview!.leading
            spaceImageView.trailing == spaceImageView.superview!.trailing
            spaceImageView.bottom == nameStackView.top - 16
            nameStackView.leading == nameStackView.superview!.leading
            nameStackView.bottom == nameStackView.superview!.bottom
            ratingStackView.trailing == ratingStackView.superview!.trailing
        }
        
    }
}
