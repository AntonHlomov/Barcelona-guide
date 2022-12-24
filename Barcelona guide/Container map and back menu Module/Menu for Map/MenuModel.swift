//
//  MenuModel.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 19/12/2022.
//

import Foundation
import UIKit

class StatePressButonMenu{
    var button: MenuModel
    var descriptionButon: String
    var imageButon: UIImage
    var pressButonIndex: Int = 0

    init(buton: MenuModel, pressButonIndex: Int) {
        var index = pressButonIndex
        if index == buton.description.count {
            index = 0
        }
        if  index > buton.description.count-1 {
            index = index - buton.description.count
        }
        self.button = buton
        self.pressButonIndex = index
        self.descriptionButon  = buton.description[index]
        self.imageButon = buton.image[index]
    }
}

enum MenuModel: Int,CaseIterable {
    case Profile
    case Messenger
    case StyleMode
    case MapMode
    case RoadMode
    case Location
    
    var description: [String] {
        switch self {
        case .Profile: return ["Profile"]
        case .Messenger: return ["Messenger"]
        case .StyleMode: return ["Light mode","Dark mode"]
        case .MapMode: return ["Standard map","Satellite","Hybrid","Satellite flyover", "Hybrid flyover","Muted standard"]
        case .RoadMode: return ["Walking","Car"]
        case .Location: return ["Location","Magnet location"]
        }
    }
    
    var image: [UIImage] {
        switch self {
        case .Profile: return [#imageLiteral(resourceName: "Profile2").withRenderingMode(.alwaysOriginal)]
        case .Messenger: return [#imageLiteral(resourceName: "Messenger").withRenderingMode(.alwaysOriginal)]
        case .StyleMode: return [#imageLiteral(resourceName: "sun2").withRenderingMode(.alwaysOriginal),
                                 #imageLiteral(resourceName: "icons8-символ-луны-50 (2)").withRenderingMode(.alwaysOriginal)]
        case .MapMode: return [#imageLiteral(resourceName: "icons8-map-24").withRenderingMode(.alwaysOriginal),
                               #imageLiteral(resourceName: "icons8-путеводитель-50").withRenderingMode(.alwaysOriginal),
                               #imageLiteral(resourceName: "icons8-route-30").withRenderingMode(.alwaysOriginal),
                               #imageLiteral(resourceName: "map2").withRenderingMode(.alwaysOriginal),
                               #imageLiteral(resourceName: "map").withRenderingMode(.alwaysOriginal),
                               #imageLiteral(resourceName: "icons8-мир-50").withRenderingMode(.alwaysOriginal)]
        case .RoadMode: return [#imageLiteral(resourceName: "icons8-whalk-30").withRenderingMode(.alwaysOriginal),
                                #imageLiteral(resourceName: "car").withRenderingMode(.alwaysOriginal)]
        case .Location: return [#imageLiteral(resourceName: "icons8-направление-на-север-50").withRenderingMode(.alwaysOriginal),
                                #imageLiteral(resourceName: "icons8-центральное-направление-50").withRenderingMode(.alwaysOriginal)]
            
        }
    }
}
