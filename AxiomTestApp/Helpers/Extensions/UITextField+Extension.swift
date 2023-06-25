//
//  UITextField+Extension.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 25/06/2023.
//

import Foundation
import UIKit

extension UITextField {
    func setPlaceholderColor(_ color: UIColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        guard let placeholder = placeholder else { return }
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
//        if LanguageManager.isCurrentLanguageRTL() {
//            self.rightView = paddingView
//            self.rightViewMode = .always
//        }else {
            self.leftView = paddingView
            self.leftViewMode = .always
//        }
    }
}
