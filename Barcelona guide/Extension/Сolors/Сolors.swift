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
    case grayPlatinum
    case grayMidle
    case bluePewter
    case redLightSalmon
    case redDarkSalmon
    case pinkLightSalmon
    case orangeChinese
    case blackVampire

    case platinumOrblackDarckMode
    case blackOrPlatinumDarckMode
    case pinkOrPlatinumDarckMode
    case platinumPinkOrDarckMode
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .grayMidle:
            return  UIColor.rgb(red: 124, green: 133, blue: 132)
        case .grayPlatinum:
            return  UIColor.rgb(red: 228, green: 228, blue: 228)
        case .bluePewter:
            return  UIColor.rgb(red: 133, green: 182, blue: 177)
        case .redLightSalmon:
            return  UIColor.rgb(red: 190, green: 140, blue: 196)
        case .redDarkSalmon:
            return UIColor.rgb(red: 170, green: 92, blue: 178)
        case .pinkLightSalmon:
            return  UIColor.rgb(red: 251, green: 162, blue: 162)
        case .orangeChinese:
            return  UIColor.rgb(red: 237, green: 122, blue: 60)
        case .blackVampire:
            return  UIColor.rgb(red: 10, green: 9, blue: 9)
            
        case .blackOrPlatinumDarckMode:
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return  UIColor.rgb(red: 228, green: 228, blue: 228)
                default:
                    return  UIColor.rgb(red: 10, green: 9, blue: 9)
                }
            }
            
        case .platinumOrblackDarckMode:
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return  UIColor.rgb(red: 10, green: 9, blue: 9)
                default:
                    return  UIColor.rgb(red: 228, green: 228, blue: 228)
                }
            }
            
        case .pinkOrPlatinumDarckMode:
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return  UIColor.rgb(red: 228, green: 228, blue: 228)
                default:
                    return UIColor.rgb(red: 251, green: 162, blue: 162)
                }
            }
        case .platinumPinkOrDarckMode:
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor.rgb(red: 251, green: 162, blue: 162)
                default:
                    return  UIColor.rgb(red: 228, green: 228, blue: 228)
                }
            }
        }
    }
}
