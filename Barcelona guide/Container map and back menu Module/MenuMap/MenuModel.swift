//
//  MenuModel.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 19/12/2022.
//

import Foundation
import UIKit

enum MenuModel: Int, CustomStringConvertible {
    
    case Profile
    case Menu
    case Contacts
    case Settings
    
    var description: String {
        switch self {
        case .Profile: return "Profile"
        case .Menu: return "Menu"
        case .Contacts: return "Contacts"
        case .Settings: return "Setting"
            
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile: return UIImage(named: "Profile2") ?? UIImage()
        case .Menu: return UIImage(named: "Menu2") ?? UIImage()
        case .Contacts: return UIImage(named: "Contacts") ?? UIImage()
        case .Settings: return UIImage(named: "Settings2") ?? UIImage()
            
        }
    }
    
}
