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
        stackView.insetsLayoutMarginsFromSafeArea = true
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
        stackView.insetsLayoutMarginsFromSafeArea = true
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
    
    private lazy var businessHoursTitleHorizontalStackView: UIStackView = {
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
    
    private lazy var mondayTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var mondayHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var tuesdayTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var tuesdayHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var wednesdayTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var wednesdayHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var thursdayTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var thursdayHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var fridayTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var fridayHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var saturdayTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var saturdayHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var sundayTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var sundayHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var mondayHoursRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            mondayTitleLabel,
            mondayHoursLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var tuesdayHoursRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tuesdayTitleLabel,
            tuesdayHoursLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var wednesdayHoursRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            wednesdayTitleLabel,
            wednesdayHoursLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var thursdayHoursRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            thursdayTitleLabel,
            thursdayHoursLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var fridayHoursRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            fridayTitleLabel,
            fridayHoursLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var saturdayHoursRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            saturdayTitleLabel,
            saturdayHoursLabel
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var sundayHoursRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sundayTitleLabel,
            sundayHoursLabel
        ])
        
        stackView.axis = .horizontal
//        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var hoursVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            isOpenNowLabel,
            mondayHoursRowStackView,
            tuesdayHoursRowStackView,
            wednesdayHoursRowStackView,
            thursdayHoursRowStackView,
            fridayHoursRowStackView,
            saturdayHoursRowStackView,
            sundayHoursRowStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 28, bottom: 0, trailing: 0)
        return stackView
    }()
    
    private lazy var detailsVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addressHorizontalStackView,
            phoneHorizontalStackView,
            businessHoursTitleHorizontalStackView,
            hoursVerticalStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(16.0, after: phoneHorizontalStackView)
        stackView.insetsLayoutMarginsFromSafeArea = true
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
    
    init(configuration: WorkspaceDetailContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            isOpenNowLabel.text = "Closed now"
            isOpenNowLabel.textColor = .red
        }
        
        addressLabel.text = viewModel.addressText
        phoneLabel.text = viewModel.phoneText
        mondayTitleLabel.text = viewModel.mondayText
        mondayHoursLabel.text = viewModel.mondayHours
        tuesdayTitleLabel.text = viewModel.tuesdayText
        tuesdayHoursLabel.text = viewModel.tuesdayHours
        wednesdayTitleLabel.text = viewModel.wednesdayText
        wednesdayHoursLabel.text = viewModel.wednesdayHours
        thursdayTitleLabel.text = viewModel.thursdayText
        thursdayHoursLabel.text = viewModel.thursdayHours
        fridayTitleLabel.text = viewModel.fridayText
        fridayHoursLabel.text = viewModel.fridayHours
        saturdayTitleLabel.text = viewModel.saturdayText
        saturdayHoursLabel.text = viewModel.saturdayHours
        sundayTitleLabel.text = viewModel.sundayText
        sundayHoursLabel.text = viewModel.sundayHours
    }
    
    private func setupView() {
        addSubview(containerView)
        [nameLabel,
         ratingRowStackView,
         lineView,
         detailsVerticalStackView].forEach { self.containerView.addSubview($0)}
        
        constrain(containerView, nameLabel, ratingRowStackView, lineView, detailsVerticalStackView) { containerView, nameLabel, ratingRowStackView, lineView, detailsVerticalStackView in
            containerView.edges == containerView.superview!.edges
            nameLabel.leading == nameLabel.superview!.leading + 4
            nameLabel.trailing == nameLabel.superview!.trailing - 4
            ratingRowStackView.top == nameLabel.bottom + 8
            ratingRowStackView.leading == ratingRowStackView.superview!.leading + 4
            ratingRowStackView.trailing == ratingRowStackView.superview!.trailing - 4
            lineView.top == ratingRowStackView.bottom + 8
            lineView.leading == lineView.superview!.leading + 4
            lineView.trailing == lineView.superview!.trailing - 4
            detailsVerticalStackView.top == lineView.bottom + 8
            detailsVerticalStackView.leading == detailsVerticalStackView.superview!.leading + 4
            detailsVerticalStackView.trailing == detailsVerticalStackView.superview!.trailing - 4
        }
    }
}
