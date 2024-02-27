//
//  UserProfileContentView.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 1/30/24.
//

import UIKit
import Cartography
import RealmSwift

class UserProfileContentView: UIView, UIContentView {
    
    private var viewModel = UserProfileContentViewViewModel()
    
    private lazy var userProfileImage: CircularImageView = {
       return CircularImageView(radius: 50)
    }()
    
    private lazy var userProfileNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.bodyBoldFont, size: 16)
        label.textColor = .label
        return label
    }()
    
    private lazy var nameVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userProfileImage,
            userProfileNameLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var logoutButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let button = UIButton()
        button.setAttributedTitle(viewModel.logoutText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.addTarget(self,
                         action: #selector(didTapLogout),
                         for: .touchUpInside)
        return button
    }()
    
    private var currentConfiguration: UserProfileContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        } set {
            guard let newConfiguration = newValue as? UserProfileContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: UserProfileContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLogout(sender: UIButton) {
        print("Logout tapped")
    }
    
    private func apply(configuration: UserProfileContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        self.currentConfiguration = configuration
        
        guard let userId = currentConfiguration.userId else { return }

        viewModel.fill(withUserId: userId) {
            self.populateView()
        }
    }
    
    private func populateView() {
        userProfileImage.image = viewModel.userImage
        userProfileNameLabel.text = viewModel.userNameText
    }
    
    private func setupView() {
        [nameVerticalStackView, logoutButton].forEach {addSubview($0)}
        
        constrain(nameVerticalStackView, logoutButton) { nameVerticalStackView, logoutButton in
            nameVerticalStackView.top == nameVerticalStackView.superview!.top + 12
            nameVerticalStackView.leading == nameVerticalStackView.superview!.leading + 16
            nameVerticalStackView.trailing == nameVerticalStackView.superview!.trailing - 16
            logoutButton.leading == logoutButton.superview!.leading + 12
            logoutButton.bottom == logoutButton.superview!.bottom - 12
        }
    }
}
