//
//  Hashtag.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

class Hashtag{
    var uidHashtag: String!
    var nameHashtag: String!
    
    init(dictionary: [String: Any]) {
        self.uidHashtag = dictionary["uidHashtag"] as? String ?? ""
        self.nameHashtag = dictionary["nameHashtag"] as? String ?? ""
    }
}
