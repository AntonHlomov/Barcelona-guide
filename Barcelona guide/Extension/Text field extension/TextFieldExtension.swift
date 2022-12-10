//
//  TextFieldExtension.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import UIKit

extension UITextField{
    class func setupTextField(title: String, hideText: Bool, enabled: Bool) -> UITextField {
        let tf = CustomTextField(padding: 16)
        tf.backgroundColor = UIColor(white: 1, alpha: 0.7)
        tf.layer.cornerRadius = 5
        tf.font = UIFont .systemFont(ofSize: 16)
        tf.textColor = UIColor.appColor(.grayMidle)
        tf.tintColor = UIColor.appColor(.grayMidle)
        tf.attributedPlaceholder = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.grayMidle)!] )
        tf.isSecureTextEntry = hideText         // скрытие пороля
        tf.isEnabled = enabled
        return tf
    }
}
