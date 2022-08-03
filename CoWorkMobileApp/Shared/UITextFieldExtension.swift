//
//  UITextFieldExtension.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit

extension UITextField {
    
    var isEmailValid: Bool {
        guard let text = self.text else { return false }
        
            do {
                let regex = try NSRegularExpression(pattern: "^[A-Z0-9a-z][A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                                                    options: .caseInsensitive)
                return regex.firstMatch(in: text,
                                        options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                        range: NSRange(location: 0, length: text.count)) != nil

            } catch {
                return false
            }
        }
    
    var isPasswordValid: Bool {
        guard let text = self.text else { return false }
        
        if passwordPattern.evaluate(with: text) {
            return true
        } else {
            return false
        }
    }

}
