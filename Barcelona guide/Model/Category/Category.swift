//
//  Category.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//Hashtag: увидел вещь на улице, отдаю свою вещь бесплатно, отдаю животное бесплатно, болшая скидка здесь, бесплатные услуги, здесь сейчас хорошо

import Foundation

class Category{
    var uidCategory: String!
    var nameCategory: String!
    
    init(dictionary: [String: Any]) {
        self.uidCategory = dictionary["uidCategory"] as? String ?? ""
        self.nameCategory = dictionary["nameCategory"] as? String ?? ""
    }
}
