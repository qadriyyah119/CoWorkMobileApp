//
//  UserProfileViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/10/22.
//

import UIKit
import Cartography

class UserProfileViewController: UIViewController {
    
    private lazy var userProfileImage: UIImageView = {
        let largeFont = UIFont.systemFont(ofSize: 90)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: viewModel.userImage, withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray
       return imageView
    }()
    
    private lazy var userProfileNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 18)
        return label
    }()
    
    private lazy var nameVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userProfileImage,
            userProfileNameLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var logoutButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseBackgroundColor = ThemeColors.secondaryColor
        config.baseForegroundColor = UIColor.white
        config.title = viewModel.logoutText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(didTapLogout),
                         for: .primaryActionTriggered)
        return button
    }()
    
    
    let viewModel: UserProfileViewModel
    var userId: String?
    
    init() {
        self.viewModel = UserProfileViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        populateView()
        viewModel.getUser()
    }
    
    private func setupView() {
        self.view.backgroundColor = ThemeColors.mainBackgroundColor
        [userProfileImage, userProfileNameLabel, logoutButton].forEach {self.view.addSubview($0)}
        
        constrain(userProfileImage, userProfileNameLabel, logoutButton) { userProfileImage, userProfileNameLabel, logoutButton in
            userProfileImage.centerX == userProfileImage.superview!.centerX
            userProfileImage.top == userProfileImage.superview!.top + 80
            userProfileNameLabel.top == userProfileImage.bottom + 10
            userProfileNameLabel.centerX == userProfileNameLabel.superview!.centerX
            logoutButton.centerX == logoutButton.superview!.centerX
            logoutButton.bottom == logoutButton.superview!.bottom - 16
        }
    }
    
    private func populateView() {
        userProfileNameLabel.text = viewModel.userNameText
    }
    
    @objc func didTapLogout(sender: UIButton) {
        print("Logout tapped")
    }

}
