//
//  RequestsObjects.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import Firebase
import UIKit
import GeoFire
import GeoFireUtils

protocol RequestsObjectsApiProtocol {
    func setObject(nameObject: String,categoryObject: String,textObject: String,objectImage: UIImage, longitude: Double, latitude: Double, user: User?,completion: @escaping (Result<Bool,Error>) -> Void)
}

class RequestsObjectsApi: RequestsObjectsApiProtocol{
    
    func setObject(nameObject: String,categoryObject: String,textObject: String,objectImage: UIImage, longitude: Double, latitude: Double, user: User?, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
       
        guard let nameUserСreator = user?.nameUser else {return}
        guard let fullNameUserСreator = user?.fullNameUser else {return}
        guard let profileImageUserСreator = user?.profileImageUser else {return}
        guard let emailUserСreator = user?.emailUser else {return}
        guard let karmaUserСreator = user?.karmaUser else {return}
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let hash = GFUtils.geoHash(forLocation: location)
        
        let dateCreateObject = Date()
        
        let db =  Firestore.firestore().collection("users").document(uid)
        guard let uploadObjectImage = objectImage.jpegData(compressionQuality: 0.3) else {return}
        var dataServies = [ "uidObject": hash,
                            "nameObject": nameObject,
                            "categoryObject": categoryObject,
                            "textObject": textObject,
                            "objectImage": "",
                            "latitudeObject": latitude,
                            "longitudeObject": longitude,
                            "location": hash,
                            "likeObject": 0,
                            "uidUserСreator": uid,
                            "nameUserСreator": nameUserСreator,
                            "fullNameUserСreator": fullNameUserСreator,
                            "profileImageUserСreator": profileImageUserСreator,
                            "emailUserСreator": emailUserСreator,
                            "karmaUserСreator": karmaUserСreator,
                            "dateCreateObject":dateCreateObject
        ] as [String : Any]
        let storageRef = Storage.storage().reference().child("Object_image").child(hash)
        storageRef.putData(uploadObjectImage, metadata: nil) { (_, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            //получаем обратно адрес картинки
            storageRef.downloadURL { (downLoardUrl, error) in
                guard let objectImageUrl = downLoardUrl?.absoluteString else {return}
                if let error = error {
                    completion(.failure(error))
                    return
                }
                dataServies["objectImage"] = objectImageUrl
                db.collection("objects").document(hash).setData(dataServies) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    db.updateData(["cauntAddedObjects": FieldValue.increment(Int64(1))])
                    completion(.success(true))
                }
            }
        }
    }
}
