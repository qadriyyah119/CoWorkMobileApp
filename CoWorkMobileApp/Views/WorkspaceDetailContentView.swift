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
        let imageSize = UIFont.systemFont(ofSize: 14)
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
        label.textAlignment = .left
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
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var addressHorizontalView: UIView = {
        let containerView = UIView()
        
        [addressIcon, addressLabel].forEach { containerView.addSubview($0) }
        
        addressIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        addressIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        addressIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: addressIcon.trailingAnchor, constant: 8).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        
        return containerView
    }()
    
//    private lazy var addressHorizontalStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [
//            addressIcon,
//            addressLabel
//        ])
//
//        stackView.axis = .horizontal
//        stackView.spacing = 8
//        stackView.alignment = .leading
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.insetsLayoutMarginsFromSafeArea = true
//        return stackView
//    }()
    
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
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private lazy var phoneHorizontalView: UIView = {
        let containerView = UIView()
        
        [phoneIcon, phoneLabel].forEach { containerView.addSubview($0) }
        
        phoneIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        phoneIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        phoneIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        phoneLabel.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: 8).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        phoneLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        
        return containerView
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
    
    private lazy var businessHoursTitleHorizontalView: UIView = {
        let containerView = UIView()
        
        [hoursIcon, businessHoursTitleLabel].forEach { containerView.addSubview($0) }
        
        hoursIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        hoursIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        hoursIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        businessHoursTitleLabel.leadingAnchor.constraint(equalTo: hoursIcon.trailingAnchor, constant: 8).isActive = true
        businessHoursTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        businessHoursTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        
        return containerView
    }()
    
    private lazy var hoursVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            isOpenNowLabel,
            createHoursView(weekDay: viewModel.mondayText, hours: viewModel.mondayHours),
            createHoursView(weekDay: viewModel.tuesdayText, hours: viewModel.tuesdayHours),
            createHoursView(weekDay: viewModel.wednesdayText, hours: viewModel.wednesdayHours),
            createHoursView(weekDay: viewModel.thursdayText, hours: viewModel.thursdayHours),
            createHoursView(weekDay: viewModel.fridayText, hours: viewModel.fridayHours),
            createHoursView(weekDay: viewModel.saturdayText, hours: viewModel.saturdayHours),
            createHoursView(weekDay: viewModel.sundayText, hours: viewModel.sundayHours)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 28, bottom: 0, trailing: 0)
        return stackView
    }()
    
    private lazy var detailsVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addressHorizontalView,
            phoneHorizontalView,
            businessHoursTitleHorizontalView,
            hoursVerticalStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(12.0, after: phoneHorizontalView)
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
    
    private func createHoursView(weekDay: String?, hours: String?) -> UIView {
        let hoursView = UIView()
        
        let dayLabel = UILabel()
        dayLabel.textAlignment = .left
        dayLabel.numberOfLines = 1
        dayLabel.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let hoursLabel = UILabel()
        hoursLabel.textAlignment = .right
        hoursLabel.numberOfLines = 1
        hoursLabel.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [dayLabel, hoursLabel].forEach { hoursView.addSubview($0) }
        
        dayLabel.leadingAnchor.constraint(equalTo: hoursView.leadingAnchor).isActive = true
        dayLabel.topAnchor.constraint(equalTo: hoursView.topAnchor, constant: 4).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: hoursView.bottomAnchor, constant: -4).isActive = true
        hoursLabel.trailingAnchor.constraint(equalTo: hoursView.trailingAnchor).isActive = true
        hoursLabel.topAnchor.constraint(equalTo: hoursView.topAnchor, constant: 4).isActive = true
        hoursLabel.bottomAnchor.constraint(equalTo: hoursView.bottomAnchor, constant: -4).isActive = true
        
        dayLabel.text = weekDay
        hoursLabel.text = hours
        
        return hoursView
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
