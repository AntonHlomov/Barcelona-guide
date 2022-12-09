//
//  Setings.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

class Setings{
    var uidSetings: String!
    
    init(dictionary: [String: Any]) {
        self.uidSetings = dictionary["uidSetings"] as? String ?? ""
    }
}
