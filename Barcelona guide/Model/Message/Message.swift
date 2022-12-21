//
//  Message.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import Firebase

class Message{
    
    var id: String!
    var content: String
    var created: Timestamp!
    var senderID: String!
    var senderName: String
    
    init(dictionary: [String: Any]) {
    
        self.id = dictionary["id"] as? String
        self.content = dictionary["content"] as? String ?? ""
        self.created = dictionary["created"] as? Timestamp
        self.senderID = dictionary["senderID"] as? String 
        self.senderName = dictionary["senderName"] as? String ?? ""
    
        
    }
}
