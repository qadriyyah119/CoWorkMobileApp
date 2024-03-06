//
//  UserProfileSignInRegisterViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 3/1/24.
//

import UIKit
import Cartography

protocol UserProfileSignInRegisterViewControllerDelegate: AnyObject {
    func userProfileSignInRegisterViewController(didSelectRegisterFromController: UserProfileSignInRegisterViewController)
    func userProfileSignInRegisterViewController(didSelectSignInFromController: UserProfileSignInRegisterViewController)
}

class UserProfileSignInRegisterViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.titleText
        label.textAlignment = .left
        label.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 20)
        label.textColor = .label
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.subTitleText
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 18)
        label.textColor = .label
        return label
    }()
    
    private lazy var titleVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subTitleLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private(set) lazy var registerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = viewModel.registerText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        config.baseBackgroundColor = ThemeColors.secondaryColor
        config.buttonSize = .medium
        config.cornerStyle = .small
        config.background.strokeWidth = 1
        config.background.strokeColor = ThemeColors.buttonBorder
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(registerButtonSelected),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private(set) lazy var signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = viewModel.SignInText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        config.baseBackgroundColor = .systemGray2
        config.buttonSize = .medium
        config.cornerStyle = .small
        config.background.strokeWidth = 1
        config.background.strokeColor = ThemeColors.buttonBorder
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(signInButtonSelected),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var buttonHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            registerButton,
            signInButton
        ])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    let viewModel: UserProfileSiginRegisterViewModel
    weak var delegate: UserProfileSignInRegisterViewControllerDelegate?
    
    init(viewModel: UserProfileSiginRegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        [titleLabel, subTitleLabel, buttonHorizontalStackView].forEach {self.view.addSubview($0)}
        
        constrain(titleLabel, subTitleLabel, buttonHorizontalStackView) { titleLabel, subTitleLabel, buttonHorizontalStackView in
            titleLabel.top == titleLabel.superview!.top + 120
            titleLabel.leading == titleLabel.superview!.leading + 16
            titleLabel.trailing == titleLabel.superview!.trailing - 16
            subTitleLabel.top == titleLabel.bottom + 10
            subTitleLabel.leading == subTitleLabel.superview!.leading + 16
            subTitleLabel.trailing == subTitleLabel.superview!.trailing - 16
            buttonHorizontalStackView.top == subTitleLabel.bottom + 25
            buttonHorizontalStackView.leading == buttonHorizontalStackView.superview!.leading + 16
            buttonHorizontalStackView.trailing == buttonHorizontalStackView.superview!.trailing - 16
        }
    }
    
    @objc func registerButtonSelected() {
        self.delegate?.userProfileSignInRegisterViewController(didSelectRegisterFromController: self)
    }
    
    @objc func signInButtonSelected() {
        self.delegate?.userProfileSignInRegisterViewController(didSelectSignInFromController: self)
    }
    
}
