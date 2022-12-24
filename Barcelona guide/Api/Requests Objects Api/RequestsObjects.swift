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
    func getObjectsNearUser(user: User?,radius: Double,latitudeUser: Double,longitudeUser: Double,compleation: @escaping (Result<[Object]?, Error>) -> Void)
    
    func setObject(nameObject: String,categoryObject: String,textObject: String,objectImage: UIImage, longitude: Double, latitude: Double, user: User?,completion: @escaping (Result<Bool,Error>) -> Void)
}

class RequestsObjectsApi: RequestsObjectsApiProtocol{

    func getObjectsNearUser(user: User?,radius: Double,latitudeUser: Double,longitudeUser: Double,compleation: @escaping (Result<[Object]?, Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let center = CLLocationCoordinate2D(latitude: latitudeUser, longitude: longitudeUser)
        let radiusInM: Double = radius  //50 * 1000
        
        let db =  Firestore.firestore().collection("users").document(uid)
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInM)
        let queries = queryBounds.map { bound -> Query in
            return db.collection("objects")
                .order(by: "location")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }

        var objects = [Object]()
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
            guard (snapshot?.documents) != nil else {
                if let error = error {
                    print("Unable to fetch snapshot data. \(String(describing: error))")
                    compleation(.failure(error))
                }
            return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
            let lat = documentSnapshot.data()["latitudeObject"] as? Double ?? 0
            let lng = documentSnapshot.data()["longitudeObject"] as? Double ?? 0
            let coordinates = CLLocation(latitude: lat, longitude: lng)
            let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                if distance <= radiusInM {
                    let objectDictionary = documentSnapshot.data()
                    let object = Object(dictionary: objectDictionary)
                        objects.append(object)
                }
            })
            compleation(.success(objects))
        }
        for query in queries {
            query.getDocuments(completion: getDocumentsCompletion)
        }
    }
    
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
