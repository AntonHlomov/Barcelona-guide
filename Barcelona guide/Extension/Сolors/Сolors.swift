//
//  Сolors.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import UIKit
// функция для цветов в приложении
extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

enum AssetsColor {
    case whiteOrDark
    case pinkOrWhite
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .whiteOrDark:
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return  UIColor.rgb(red: 38, green: 38, blue: 38)
                default:
                    return  UIColor.rgb(red: 255, green: 255, blue: 255).withAlphaComponent(0.6)
                }
            }
            
        case .pinkOrWhite:
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return  UIColor.rgb(red: 255, green: 255, blue: 255).withAlphaComponent(0.6)
                default:
                    return UIColor.rgb(red: 190, green: 140, blue: 196)
                }
            }
        }
    }
}
