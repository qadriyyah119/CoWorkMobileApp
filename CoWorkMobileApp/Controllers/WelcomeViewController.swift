//
//  WelcomeViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import Cartography

class WelcomeViewController: UIViewController {
    
    private(set) lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.logo)
        return imageView
    }()
    
    private(set) lazy var logInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = viewModel.loginButtonText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        
        let button = OutlinedButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(loginButtonSelected),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private(set) lazy var registerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = viewModel.registerButtonText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        
        let button = OutlinedButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(registerButtonSelected),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private(set) lazy var skipButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = viewModel.skipButtonText
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.addTarget(self,
                         action: #selector(skipButtonSelected),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var buttonHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logInButton,
            registerButton
        ])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHorizontalStackView,
            skipButton
        ])
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        stackView.setCustomSpacing(18, after: buttonHorizontalStackView)
        return stackView
    }()
    
    let viewModel = WelcomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColors.grayColor
        self.setupView()
    }
    
    private func setupView() {
        self.view.addSubview(logoImageView)
        self.view.addSubview(contentStackView)
        
        constrain(logoImageView, contentStackView) { logoImageView, contentStackView in
            logoImageView.centerX == logoImageView.superview!.centerX
            logoImageView.centerY == logoImageView.superview!.centerY - 150
            contentStackView.leading == contentStackView.superview!.leading + 16
            contentStackView.trailing == contentStackView.superview!.trailing - 16
            contentStackView.bottom == contentStackView.superview!.bottom - 40
        }
    }
    
    @objc func registerButtonSelected() {
        let registerViewController = AccountRegistrationViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @objc func loginButtonSelected() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc func skipButtonSelected() {
        let tabBarViewController = RootTabBarController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(toNewView: tabBarViewController)
    }
}
