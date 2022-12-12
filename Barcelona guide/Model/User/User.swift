//
//  User.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

class User{
    
    var uidUser: String!
    var nameUser: String!
    var fullNameUser: String!
    var profileImageUser: String!
    var emailUser: String!
    var karmaUser: Int!
    var cauntAddedObjects: Int!
    
    init(dictionary: [String: Any]) {
        self.uidUser = dictionary["uidUser"] as? String ?? ""
        self.nameUser = dictionary["nameUser"] as? String ?? ""
        self.fullNameUser = dictionary["fullNameUser"] as? String ?? ""
        self.profileImageUser = dictionary["profileImageUser"] as? String ?? ""
        self.emailUser = dictionary["emailUser"] as? String ?? ""
        self.karmaUser = dictionary["karmaUser"]  as? Int ?? nil
        self.cauntAddedObjects = dictionary["cauntAddedObjects"]  as? Int ?? nil
    }
}
