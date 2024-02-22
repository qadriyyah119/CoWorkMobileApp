//
//  LoginViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/8/22.
//

import UIKit
import Cartography
import NotificationBannerSwift
import AuthenticationServices

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewController(controller: LoginViewController, didLoginSuccessfully withUser: String)
    func loginViewController(didSelectRegisterFromController: LoginViewController)
}

class LoginViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.titleText
        label.textAlignment = .left
        label.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 16)
        return label
    }()
    
    private lazy var emailTextField: TextFieldWithPadding = {
        let textField = makeStyledInputField()
        textField.placeholder = viewModel.emailPlaceholderText
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var passwordTextField: TextFieldWithPadding = {
        let textfield = makeStyledInputField()
        textfield.placeholder = viewModel.passwordPlaceholderText
        textfield.clearButtonMode = .whileEditing
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        textfield.textContentType = .password
        return textfield
    }()
    
    private(set) lazy var signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = viewModel.signInButtonText
        config.baseBackgroundColor = ThemeColors.secondaryColor
        config.buttonSize = .medium
        config.cornerStyle = .small
        config.background.strokeWidth = 1
        config.background.strokeColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var config = button.configuration
            config?.showsActivityIndicator = self.signingIn
            config?.imagePlacement = self.signingIn ? .leading : .trailing
            config?.title = self.signingIn ? self.viewModel.sigingInText : self.viewModel.signInButtonText
            button.isEnabled = !self.signingIn
            button.configuration = config
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(login),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.orText
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(loginWithAppleId), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.registerText
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        return label
    }()
    
    private(set) lazy var registerButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = viewModel.registerButtonText
        config.baseForegroundColor = UIColor.black
        config.attributedTitle?.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 16)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.addTarget(self,
                         action: #selector(registerButtonSelected),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var registerHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            registerLabel,
            registerButton
        ])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            emailTextField,
            passwordTextField,
            signInButton,
            orLabel,
            appleSignInButton
        ])
        
        constrain(appleSignInButton) { appleSignInButton in
            appleSignInButton.height == 50
        }
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        stackView.setCustomSpacing(25, after: titleLabel)
        stackView.setCustomSpacing(15, after: passwordTextField)
        stackView.setCustomSpacing(15, after: signInButton)
        stackView.setCustomSpacing(15, after: orLabel)
        return stackView
    }()
    
    var signingIn = false {
        didSet {
            signInButton.setNeedsUpdateConfiguration()
        }
    }
    
    let viewModel: LoginViewModel
    weak var delegate: LoginViewControllerDelegate?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        performExistingAccountSetupFlows()
    }
    
    private func setupView() {
        self.view.backgroundColor = ThemeColors.mainBackgroundColor
        self.view.addSubview(contentStackView)
        self.view.addSubview(registerHorizontalStackView)
        
        constrain(contentStackView, registerHorizontalStackView) { contentStackView, registerHorizontalStackView in
            contentStackView.top == contentStackView.superview!.top + 120
            contentStackView.leading == contentStackView.superview!.leading + 16
            contentStackView.trailing == contentStackView.superview!.trailing - 16
            registerHorizontalStackView.top == contentStackView.bottom + 25
            registerHorizontalStackView.centerX == registerHorizontalStackView.superview!.centerX
        }
    }
    
    @objc func login() {
        guard self.validateForm() else { return }
        self.signingIn = true
        
        viewModel.didTapLogin(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { result in
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                switch result {
                case .success(let user):
                        Banner.showBanner(withTitle: "Success!", subtitle: "Welcome \(user)", style: .success)
                        self.signingIn = false
                    
                    self.delegate?.loginViewController(controller: self, didLoginSuccessfully: self.viewModel.user)
                case .failure(let error):
                    Banner.showBanner(withTitle: "Error", subtitle: "\(error.description). Please try again", style: .danger)
                        self.signingIn = false
                }
            }
        }
    }
    
    @objc func loginWithAppleId() {
        print("Pressed signin with Apple ID")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func registerButtonSelected() {
        self.delegate?.loginViewController(didSelectRegisterFromController: self)
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func validateForm() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            Banner.showBanner(withTitle: "Login Error!", subtitle: "Please complete all fields, and try again.", style: .danger)
            return false
        }
        
        return true
    }
    
    private func makeStyledInputField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 12)
        textField.borderStyle = .line
        textField.layer.borderColor = ThemeColors.secondaryColor?.cgColor
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("ERROR: Apple ID Sign In Error!")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            
            // Navigate to other view controller. Call delegate to go to WorkspaceListVC
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // Navigate to other view controller. Call delegate to go to WorkspaceListVC
        }
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
