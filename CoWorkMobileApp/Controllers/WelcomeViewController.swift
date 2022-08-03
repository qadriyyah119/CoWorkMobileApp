//
//  WelcomeViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import Cartography

class WelcomeViewController: UIViewController {

    enum LoginStrings {
        static let signinText = "Sign In"
        static let signingInText = "Signing In..."
        static let usernameText = "Username"
        static let passwordText = "Password"
        static let loginText = "LOG IN"
        static let registerText = "REGISTER"
        static let skipText = "SKIP"
    }

    private(set) lazy var logInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = LoginStrings.loginText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)

        let button = OutlinedButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self,
//                         action: #selector(login),
//                         for: .primaryActionTriggered)

        return button
      }()
    
    private(set) lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.logo)
        return imageView
    }()
    
    private(set) lazy var registerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = LoginStrings.registerText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)

        let button = OutlinedButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self,
//                         action: #selector(login),
//                         for: .primaryActionTriggered)

        return button
      }()
    
    private(set) lazy var skipButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = LoginStrings.skipText
        let button = UIButton()
        button.configuration = config
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

}

class OutlinedButton: UIButton {
    override func updateConfiguration() {
        guard let configuration = configuration else { return }
        
        var updatedConfiguration = configuration
        var background = UIButton.Configuration.plain().background
        background.cornerRadius = 8
        background.strokeWidth = 1
        
        let strokeColor: UIColor
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        
        switch self.configuration?.title {
        case WelcomeViewController.LoginStrings.loginText:
            strokeColor = ThemeColors.secondaryColor ?? .black
            foregroundColor = ThemeColors.secondaryColor ?? .black
            backgroundColor = ThemeColors.mainBackgroundColor ?? .white
        case WelcomeViewController.LoginStrings.registerText:
            strokeColor = ThemeColors.secondaryColor ?? .black
            foregroundColor = .white
            backgroundColor = ThemeColors.secondaryColor ?? .black
        default:
            strokeColor = .black
            foregroundColor = .black
            backgroundColor = .white
        }
        
        background.strokeColor = strokeColor
        background.backgroundColor = backgroundColor
        
        updatedConfiguration.baseForegroundColor = foregroundColor
        updatedConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30)
        updatedConfiguration.background = background
        
        self.configuration = updatedConfiguration
    }
}
