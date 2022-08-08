//
//  LoginViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/8/22.
//

import UIKit
import Cartography
import NotificationBannerSwift

class LoginViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.titleText
        label.textAlignment = .left
        label.font = UIFont(name: ThemeFonts.headerFont, size: 37)
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
        
//        textfield.addTarget(self,
//                            action: #selector(textFieldDidChange(_:)),
//                            for: .editingChanged)
        return textfield
      }()
    
    private(set) lazy var loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = viewModel.signInButtonText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)

        let button = OutlinedButton(configuration: config, primaryAction: nil)

        button.configurationUpdateHandler = { [weak self] button in
          guard let self = self else { return }
          var config = button.configuration

            config?.showsActivityIndicator = self.logingIn
            config?.imagePlacement = self.logingIn ? .leading : .trailing

            config?.title = self.logingIn ? self.viewModel.sigingInText : self.viewModel.signInButtonText
          button.isEnabled = !self.logingIn

          button.configuration = config
        }

        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self,
//                         action: #selector(createAccount),
//                         for: .primaryActionTriggered)

        return button
      }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
          titleLabel,
          emailTextField,
          passwordTextField,
          loginButton
        ])

        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        stackView.setCustomSpacing(25, after: titleLabel)
        stackView.setCustomSpacing(10, after: passwordTextField)

        return stackView
      }()
    
    
    let viewModel = LoginViewModel()
    
    private var logingIn = false {
        didSet {
          loginButton.setNeedsUpdateConfiguration()
        }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = ThemeColors.mainBackgroundColor
        self.view.addSubview(contentStackView)

        constrain(contentStackView) { contentStackView in
            
            contentStackView.top == contentStackView.superview!.top + 120
            contentStackView.leading == contentStackView.superview!.leading + 16
            contentStackView.trailing == contentStackView.superview!.trailing - 16
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
