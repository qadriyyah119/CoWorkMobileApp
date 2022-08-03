//
//  CustomUIButton.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit

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
        case WelcomeViewModel.LoginStrings.loginText:
            strokeColor = ThemeColors.secondaryColor ?? .black
            foregroundColor = ThemeColors.secondaryColor ?? .black
            backgroundColor = ThemeColors.mainBackgroundColor ?? .white
        case WelcomeViewModel.LoginStrings.registerText, AccountRegistrationViewModel.RegisterStrings.signUpText:
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
