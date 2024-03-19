//
//  WelcomeViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import Cartography

protocol WelcomeViewControllerDelegate: AnyObject {
    func welcomeViewController(userSelectedLoginFrom controller: WelcomeViewController)
    func welcomeViewController(userSelectedRegisterFrom controller: WelcomeViewController)
    func welcomeViewController(userSelectedSkipFrom controller: WelcomeViewController)
}

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
    
    let viewModel: WelcomeViewModel
    weak var delegate: WelcomeViewControllerDelegate?
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColors.grayColor
        self.setupView()
    }
    
    private func setupView() {
        self.view.addSubview(logoImageView)
//        self.view.addSubview(contentStackView)
        
        constrain(logoImageView) { logoImageView in
            logoImageView.centerX == logoImageView.superview!.centerX
            logoImageView.centerY == logoImageView.superview!.centerY - 150
//            contentStackView.leading == contentStackView.superview!.leading + 16
//            contentStackView.trailing == contentStackView.superview!.trailing - 16
//            contentStackView.bottom == contentStackView.superview!.bottom - 40
        }
    }
    
    @objc func registerButtonSelected() {
        self.delegate?.welcomeViewController(userSelectedRegisterFrom: self)
    }
    
    @objc func loginButtonSelected() {
        self.delegate?.welcomeViewController(userSelectedLoginFrom: self)
    }
    
    @objc func skipButtonSelected() {
        self.delegate?.welcomeViewController(userSelectedSkipFrom: self)
    }
}
