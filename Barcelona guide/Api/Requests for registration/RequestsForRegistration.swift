//
//  RequestsForRegistration.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import Firebase
import UIKit

protocol RegistrationApiProtocol {
    func registration(photoUser: UIImage, emailAuth: String, name: String, passwordAuth: String,completion: @escaping (Result<Bool,Error>) -> Void)
    
}
class RegistrationApi: RegistrationApiProtocol{
    func registration(photoUser: UIImage, emailAuth: String, name: String, passwordAuth: String, completion: @escaping (Result<Bool, Error>) -> Void) {

       // DispatchQueue.global(qos: .utility).async {
            Auth.auth().createUser(withEmail: emailAuth, password: passwordAuth) {
                (user, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let uploadDataPhoto = photoUser.jpegData(compressionQuality: 0.3)  else {return}
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let idPhoto = uid
                //код загрузки фото
                let storageRef = Storage.storage().reference().child("user_profile_image").child(idPhoto)
                storageRef.putData(uploadDataPhoto, metadata: nil) { (self, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    //получаем обратно адрес картинки
                    storageRef.downloadURL { (downLoardUrl, error) in
                        guard let profileImageUrl = downLoardUrl?.absoluteString else {return}
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        guard let uid = Auth.auth().currentUser?.uid else {return}
                        
                        let docData = ["uidUser": uid,
                                       "nameUser": name,
                                       "fullNameUser": "",
                                       "emailUser": emailAuth,
                                       "profileImageUser": profileImageUrl,
                                       "karmaUser": 0,
                                       "cauntAddedObjects":0 ] as [String : Any]
                        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
                            if let error = error {
                                completion(.failure(error))
                                return
                            }
                            //Успешна сохранены данные
                            completion(.success(true))
                        }
                    }
                }
            }
        }
   // }
    
}
