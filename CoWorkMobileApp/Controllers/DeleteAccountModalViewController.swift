//
//  DeleteAccountModalViewController.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 2/20/24.
//

import UIKit
import Cartography

protocol DeleteAccountModalViewControllerDelegate: AnyObject {
    func deleteAccountModalViewController(controller: DeleteAccountModalViewController, userDeletedAccountSuccessfully withUser: String)
}

class DeleteAccountModalViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.titleText
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: ThemeFonts.headerFont, size: 25)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.messageText
        label.textAlignment = .center
        label.font = UIFont(name: ThemeFonts.bodyFont, size: 16)
        label.textColor = .label
        label.numberOfLines = 0
        return label
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
    
    private(set) lazy var cancelButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = UIColor.black
        config.buttonSize = .large
        config.cornerStyle = .small
        config.background.strokeWidth = 1
        config.background.strokeColor = .black
        config.title = viewModel.cancelButtonText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(didSelectCancel),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private(set) lazy var deleteButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = UIColor.red
        config.buttonSize = .large
        config.cornerStyle = .small
        config.background.strokeWidth = 1
        config.background.strokeColor = .black
        config.title = viewModel.deleteButtonText
        config.attributedTitle?.font = UIFont(name: ThemeFonts.buttonFont, size: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(didSelectDelete),
                         for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var buttonHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            cancelButton,
            deleteButton
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
            titleLabel,
            messageLabel,
            passwordTextField,
            buttonHorizontalStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insetsLayoutMarginsFromSafeArea = true
        stackView.setCustomSpacing(25, after: titleLabel)
        stackView.setCustomSpacing(20, after: passwordTextField)
        return stackView
    }()
    
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
    
    var viewModel: DeleteAccountViewModel
    weak var delegate: DeleteAccountModalViewControllerDelegate?
    
    init(viewModel: DeleteAccountViewModel) {
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
            contentStackView.top == contentStackView.superview!.top + 80
            contentStackView.centerX == contentStackView.superview!.centerX
        }
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true)
    }
    
    @objc func didSelectDelete() {
        guard let password = passwordTextField.text, !password.isEmpty else {
            Banner.showBanner(withTitle: "Error!", subtitle: "Please enter a valid password", style: .danger)
            return
        }
        viewModel.didTapDeleteAccount(userId: viewModel.userId, password: password) {
            self.dismiss(animated: true) {
                self.delegate?.deleteAccountModalViewController(controller: self, userDeletedAccountSuccessfully: self.viewModel.userId)
            }
        }
    }
    
}
