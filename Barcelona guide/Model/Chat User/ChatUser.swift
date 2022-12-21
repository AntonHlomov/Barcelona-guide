//
//  ChatUser.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 18/12/2022.
//

import Foundation

class ChatUser {
    
    var id: String
    var userId: String
    var displayName: String
    var displayFullName: String
    var displayProfileImageUser: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
        self.displayName = dictionary["displayName"] as? String ?? ""
        self.displayFullName = dictionary["displayFullName"] as? String ?? ""
        self.displayProfileImageUser = dictionary["displayProfileImageUser"] as? String ?? ""
    }
}
