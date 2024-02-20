//
//  UserProfileViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/10/22.
//

import UIKit
import Cartography
import Combine

protocol UserProfileViewControllerDelegate: AnyObject {
    func userProfileViewController(controller: UserProfileViewController, userLoggedOutSuccessfully withUser: String)
}

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
        config.buttonSize = .medium
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
    
    private(set) lazy var deleteAccountButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = viewModel.deleteText
        config.baseForegroundColor = UIColor.red
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.addTarget(self,
                         action: #selector(deleteButtonSelected),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var accountActionsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoutButton,
            deleteAccountButton
        ])
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        stackView.spacing = 10
        return stackView
    }()
    
    let viewModel: UserProfileViewModel
    weak var delegate: UserProfileViewControllerDelegate?
    
    var userId: String = "" {
        didSet {
            viewModel.userId = userId
        }
    }
    
    init(userId: String) {
        self.userId = userId
        self.viewModel = UserProfileViewModel(userId: self.userId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        populateView()
    }
    
    private func setupView() {
        self.view.backgroundColor = ThemeColors.mainBackgroundColor
        [userProfileImage, userProfileNameLabel, accountActionsStackView].forEach {self.view.addSubview($0)}
        
        constrain(userProfileImage, userProfileNameLabel, accountActionsStackView) { userProfileImage, userProfileNameLabel, accountActionsStackView in
            userProfileImage.centerX == userProfileImage.superview!.centerX
            userProfileImage.top == userProfileImage.superview!.top + 80
            userProfileNameLabel.top == userProfileImage.bottom + 10
            userProfileNameLabel.centerX == userProfileNameLabel.superview!.centerX
            accountActionsStackView.centerX == accountActionsStackView.superview!.centerX
            accountActionsStackView.bottom == accountActionsStackView.superview!.bottom - 16
        }
    }
    
    private func populateView() {
        userProfileNameLabel.text = viewModel.userNameText
    }
    
    @objc func didTapLogout() {
        print("Logout tapped")
        viewModel.didTapLogOut(userId: userId) {
            self.delegate?.userProfileViewController(controller: self, userLoggedOutSuccessfully: self.userId)
        }
    }
    
    @objc func deleteButtonSelected() {
        print("Delete Account tapped")
    }

}
