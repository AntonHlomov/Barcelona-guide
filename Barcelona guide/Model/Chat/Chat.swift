//
//  Chat.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 18/12/2022.
//

import Foundation

class Chat {

var id: String
var users: [String]


    init?(dictionary: [String: Any]) {
    guard let chatUsers = dictionary["users"] as? [String] else {return nil}
    guard let id = dictionary["id"] as? String else {return nil}
    self.id = id
    self.users = chatUsers



 }
}
