//
//  AccountRegistrationViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import RealmSwift
import Cartography
import NotificationBannerSwift

protocol AccountRegistrationViewControllerDelegate: AnyObject {
    func accountRegistrationViewController(controller: AccountRegistrationViewController, didRegisterSuccessfully withUser: String)
}

class AccountRegistrationViewController: UIViewController, AlertingViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.titleText
        label.textAlignment = .left
        label.font = UIFont(name: ThemeFonts.bodyFontMedium, size: 20)
        label.textColor = .label
        return label
    }()
    
    private(set) lazy var emailTextField: TextFieldWithPadding = {
        let textField = makeStyledInputField()
        textField.placeholder = viewModel.emailPlaceholderText
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
    }()
    
    private(set) lazy var usernameTextField: TextFieldWithPadding = {
        let textField = makeStyledInputField()
        textField.placeholder = viewModel.usernamePlaceholderText
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
    }()
    
    private(set) lazy var passwordTextField: TextFieldWithPadding = {
        let textfield = makeStyledInputField()
        textfield.placeholder = viewModel.passwordPlaceholderText
        textfield.clearButtonMode = .whileEditing
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        textfield.textContentType = .password
        
        textfield.addTarget(self,
                            action: #selector(textFieldDidChange(_:)),
                            for: .editingChanged)
        return textfield
    }()
    
    private lazy var passwordValidationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = viewModel.passwordValidationText
        label.textColor = .label
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var completeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = viewModel.completeButtonText
        config.baseBackgroundColor = ThemeColors.secondaryColor
        config.buttonSize = .medium
        config.cornerStyle = .small
        config.background.strokeWidth = 1
        config.background.strokeColor = ThemeColors.buttonBorder
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var config = button.configuration
            
            config?.showsActivityIndicator = self.creatingAccount
            config?.imagePlacement = self.creatingAccount ? .leading : .trailing
            config?.title = self.creatingAccount ? self.viewModel.registeringText : self.viewModel.completeButtonText
            button.isEnabled = !self.creatingAccount
            button.configuration = config
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(createAccount),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            emailTextField,
            usernameTextField,
            passwordTextField,
            passwordValidationLabel,
            completeButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        stackView.setCustomSpacing(25, after: titleLabel)
        stackView.setCustomSpacing(10, after: passwordTextField)
        return stackView
    }()
    
    var creatingAccount = false {
        didSet {
            completeButton.setNeedsUpdateConfiguration()
        }
    }
    
    var email: String = ""
    var password: String = ""
    var username: String = ""
    var isPasswordValid = false
    let viewModel: AccountRegistrationViewModel
    weak var delegate: AccountRegistrationViewControllerDelegate?
    
    init(viewModel: AccountRegistrationViewModel) {
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
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(contentStackView)
        
        constrain(contentStackView) { contentStackView in
            contentStackView.top == contentStackView.superview!.top + 120
            contentStackView.leading == contentStackView.superview!.leading + 16
            contentStackView.trailing == contentStackView.superview!.trailing - 16
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let specialCharacters = CharacterSet(charactersIn: "$@#!%*?&")
        if let password = passwordTextField.text {
            viewModel.passwordValidationText.addAttributes(setupAttributedColor(if: (password.count >= 8)),
                                                           range: findRange(in: viewModel.passwordValidationText.string, for: "at least 8 characters"))
            viewModel.passwordValidationText.addAttributes(setupAttributedColor(if: (password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil)),
                                                           range: findRange(in: viewModel.passwordValidationText.string, for: "one upper case letter"))
            viewModel.passwordValidationText.addAttributes(setupAttributedColor(if: (password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil)),
                                                           range: findRange(in: viewModel.passwordValidationText.string, for: "one lower case letter"))
            viewModel.passwordValidationText.addAttributes(setupAttributedColor(if: (password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil)),
                                                           range: findRange(in: viewModel.passwordValidationText.string, for: "one number"))
            viewModel.passwordValidationText.addAttributes(setupAttributedColor(if: (password.rangeOfCharacter(from: specialCharacters) != nil)),
                                                           range: findRange(in: viewModel.passwordValidationText.string, for: "a special character"))
            self.isPasswordValid = true
        } else {
            isPasswordValid = false
        }
        
        passwordValidationLabel.attributedText = viewModel.passwordValidationText
    }
    
    func setupAttributedColor(if isValid: Bool) -> [NSAttributedString.Key: Any] {
        if isValid {
            return [NSAttributedString.Key.foregroundColor: UIColor.blue]
        } else {
            self.isPasswordValid = false
            return [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    
    private func findRange(in baseString: String, for subString: String) -> NSRange {
        if let range = baseString.localizedStandardRange(of: subString) {
            let startIndex = baseString.distance(from: baseString.startIndex, to: range.lowerBound)
            let length = subString.count
            return NSMakeRange(startIndex, length)
        } else {
            print("Range does not exist in the base string.")
            return NSMakeRange(0, 0)
        }
    }
    
    func validateForm() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty, let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            Banner.showBanner(withTitle: "Error!", subtitle: "Please complete all fields", style: .danger)
            return false
        }
        
        guard emailTextField.isEmailValid else {
            Banner.showBanner(withTitle: "Email Error!", subtitle: "Please enter a valid email", style: .danger)
            return false
        }
        
        guard passwordTextField.isPasswordValid else {
            Banner.showBanner(withTitle: "Password Error!", subtitle: "Please enter a valid password", style: .danger)
            return false
        }
        
        do {
            try Realm().addUnique(User.self, uniqueKeyPath: "email", value: email)
        } catch {
            Banner.showBanner(withTitle: "Error!", subtitle: "Email already exist. Please try again", style: .danger)
            return false
        }
        
        do {
            try Realm().addUnique(User.self, uniqueKeyPath: "username", value: username)
        } catch {
            Banner.showBanner(withTitle: "Error!", subtitle: "Username already exist. Please try again", style: .danger)
            return false
        }
        
        self.email = email
        self.password = password
        self.username = username
        return true
    }
    
    @objc func createAccount() {
        guard self.validateForm() else { return }
        
        self.creatingAccount = true
        
        UserManager.shared.createUser(with: emailTextField.text ?? "", username: usernameTextField.text ?? "", password: passwordTextField.text ?? "") { result in

            switch result {
            case .failure(let error):
                print(error)
                Banner.showBanner(withTitle: "Error!", subtitle: "Unable to create account. Please try again.", style: .warning)
            case .success:
                    self.viewModel.userRegistered(withEmail: self.email, password: self.password) {
                        self.delegate?.accountRegistrationViewController(controller: self, didRegisterSuccessfully: self.viewModel.user)
                    }
                    self.creatingAccount = false
            }
        }

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

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
