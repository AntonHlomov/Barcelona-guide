//
//  Route.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 05/01/2022.
//

import Foundation
import MapKit


class Route {
    
    var idUser: String!
    var imageUser: String!
    var nameUser: String!
    var shurnameUser: String!
    
    var idRoute: String!
    var imageRoute: String!
    var nameRoute: String!
    var textAboutRoute: String!
   // var annotationsForRoute = [MKPointAnnotation]()
    var distanceRoute: Double!
    
     
    init(dictionary: [String: Any]) {
        
       self.idUser = dictionary["idUser"] as? String ?? ""
       self.imageUser = dictionary["imageUser"] as? String ?? ""
       self.nameUser = dictionary["nameUser"] as? String ?? ""
       self.shurnameUser = dictionary["shurnameUser"] as? String ?? ""
        
       self.idRoute = dictionary["idRoute"] as? String ?? ""
       self.imageRoute = dictionary["imageRoute"] as? String ?? ""
       self.nameRoute = dictionary["nameRoute"] as? String ?? ""
       self.textAboutRoute = dictionary["textAboutRoute"] as? String ?? ""
      //  self.annotationsForRoute = dictionary["annotationsForRoute"] as? [MKPointAnnotation?]()
       self.distanceRoute = dictionary["distanceRoute"] as? Double ?? nil
    
    }
}

