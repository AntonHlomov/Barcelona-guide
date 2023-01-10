//
//  Object.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import CoreLocation
import MapKit

class Object: MKPointAnnotation{
    
    var uidObject: String!
    var nameObject: String!
    var idCategoryObject: String! // значения Hashtag
    var categoryObject: String! // значения Hashtag
    var textObject: String!
    var objectImage: String!
    var latitudeObject: Double!
    var longitudeObject: Double!
    var location: CLLocationCoordinate2D!
    var likeObject: Int!
    var dateCreateObject: Date!
   
    var uidUserСreator: String!
    var nameUserСreator: String!
    var fullNameUserСreator: String!
    var profileImageUserСreator: String!
    var emailUserСreator: String!
    var karmaUserСreator: Int!
    
    init(dictionary: [String: Any]) {
        
        self.uidObject = dictionary["uidObject"] as? String ?? ""
        self.nameObject = dictionary["nameObject"] as? String ?? ""
        self.categoryObject = dictionary["categoryObject"] as? String ?? ""
        self.textObject = dictionary["textObject"] as? String ?? ""
        self.objectImage = dictionary["objectImage"] as? String ?? ""
        self.latitudeObject = dictionary["latitudeObject"]  as? Double ?? nil
        self.dateCreateObject = dictionary["dateCreateObject"]  as? Date ?? nil
        self.longitudeObject = dictionary["longitudeObject"]  as? Double ?? nil
        self.location = dictionary["location"]  as? CLLocationCoordinate2D ?? nil
        self.likeObject = dictionary["likeObject"]  as? Int ?? nil
        self.uidUserСreator = dictionary["uidUserСreator"] as? String ?? ""
        self.nameUserСreator = dictionary["nameUserСreator"] as? String ?? ""
        self.fullNameUserСreator = dictionary["fullNameUserСreator"] as? String ?? ""
        self.profileImageUserСreator = dictionary["profileImageUserСreator"] as? String ?? ""
        self.emailUserСreator = dictionary["emailUserСreator"] as? String ?? ""
        self.karmaUserСreator = dictionary["karmaUserСreator"]  as? Int ?? nil
    
        
        super.init()
        self.title = nameObject
        self.subtitle = textObject
        self.coordinate = CLLocationCoordinate2D(latitude: latitudeObject, longitude: longitudeObject)
     
    
    }
    
}
