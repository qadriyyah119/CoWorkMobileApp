//
//  WorkspaceDetailContentView.swift
//  CoWorkMobileApp
//


import UIKit
import Cartography

class WorkspaceDetailContentView: UIView, UIContentView {
    
    private var viewModel = WorkspaceDetailContentViewViewModel()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 22)
        return label
    }()
    
    private lazy var ratingStar: UIImageView = {
        let imageSize = UIFont.systemFont(ofSize: 12)
        let config = UIImage.SymbolConfiguration(font: imageSize)
        let image = UIImage(systemName: "star.fill", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 14)
        return label
    }()
    
    private lazy var reviewCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 14)
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
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
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var ratingRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            ratingStackView,
            distanceLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var isOpenNowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyBoldFont, size: 16)
        return label
    }()
    
    private lazy var addressIcon: UIImageView = {
        let imageSize = UIFont.systemFont(ofSize: 16)
        let config = UIImage.SymbolConfiguration(font: imageSize)
        let image = UIImage(systemName: "location", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var addressHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addressIcon,
            addressLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var phoneIcon: UIImageView = {
        let imageSize = UIFont.systemFont(ofSize: 16)
        let config = UIImage.SymbolConfiguration(font: imageSize)
        let image = UIImage(systemName: "phone.connection", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var phoneHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            phoneIcon,
            phoneLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var hoursIcon: UIImageView = {
        let imageSize = UIFont.systemFont(ofSize: 16)
        let config = UIImage.SymbolConfiguration(font: imageSize)
        let image = UIImage(systemName: "deskclock", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var businessHoursTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Business Hours"
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyBoldFont, size: 16)
        return label
    }()
    
    private lazy var businessHoursHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            hoursIcon,
            businessHoursTitleLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var detailsVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addressHorizontalStackView,
            phoneHorizontalStackView,
            businessHoursHorizontalStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var lineView: UIImageView = {
        let imageSize = UIFont.systemFont(ofSize: 10)
        let config = UIImage.SymbolConfiguration(font: imageSize)
        let image = UIImage(systemName: "minus", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentConfiguration: WorkspaceDetailContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        } set {
            guard let newConfiguration = newValue as? WorkspaceDetailContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    private func apply(configuration: WorkspaceDetailContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        self.currentConfiguration = configuration
        
        guard let workspaceId = currentConfiguration.workspaceId else { return }

        viewModel.fill(withWorkspaceId: workspaceId) {
            self.populateView()
        }
    }
    
    private func populateView() {
        nameLabel.text = viewModel.nameText
        distanceLabel.text = "distance"
        ratingLabel.text = viewModel.ratingText
        reviewCountLabel.text = viewModel.reviewCountText
        
        if viewModel.isOpenNow {
            isOpenNowLabel.text = "Open"
            isOpenNowLabel.textColor = ThemeColors.greenColor
        } else {
            isOpenNowLabel.text = "Closed"
            isOpenNowLabel.textColor = .red
        }
        
        addressLabel.text = viewModel.addressText
        phoneLabel.text = viewModel.phoneText
    }
    
    init(configuration: WorkspaceDetailContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        [nameLabel,
         ratingRowStackView,
         isOpenNowLabel,
         lineView,
         detailsVerticalStackView].forEach { self.containerView.addSubview($0)}
        
        constrain(containerView, nameLabel, ratingRowStackView, isOpenNowLabel, lineView, detailsVerticalStackView) { containerView, nameLabel, ratingRowStackView, isOpenNowLabel, lineView, detailsVerticalStackView in
            containerView.edges == containerView.superview!.edges
            nameLabel.leading == nameLabel.superview!.leading + 4
            nameLabel.trailing == nameLabel.superview!.trailing - 4
            ratingRowStackView.top == nameLabel.bottom + 8
            ratingRowStackView.leading == ratingRowStackView.superview!.leading + 4
            ratingRowStackView.trailing == ratingRowStackView.superview!.trailing - 4
            isOpenNowLabel.top == ratingRowStackView.bottom + 4
            isOpenNowLabel.leading == isOpenNowLabel.superview!.leading + 4
            lineView.top == isOpenNowLabel.bottom + 8
            lineView.leading == lineView.superview!.leading + 4
            lineView.trailing == lineView.superview!.trailing - 4
            detailsVerticalStackView.top == lineView.bottom + 8
            detailsVerticalStackView.leading == detailsVerticalStackView.superview!.leading + 4
            detailsVerticalStackView.trailing == detailsVerticalStackView.superview!.trailing - 4
        }
    }
}
