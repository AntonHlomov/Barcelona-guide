//
//  RequestsUser.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import Firebase

var userCache: User? {
    didSet {
     print("userCache chenging!")
    }
}

protocol RequestsUserApiProtocol {
    func verificationUser(completion: @escaping (Result<Bool,Error>) -> Void)
    func getUser(completion: @escaping (Result<User?,Error>) -> Void)
}
class RequestsUserApi: RequestsUserApiProtocol{
    func getUser(completion: @escaping (Result<User?,Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).addSnapshotListener { [] (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary:dictionary)
            userCache = user
            completion(.success(user))
        }
    }
   
    func verificationUser(completion: @escaping (Result<Bool,Error>) -> Void) {
        if Auth.auth().currentUser != nil {
            completion(.success(true))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User does not exist"])
                completion(.failure(error))
            return
        }
    }

    
                       
}
                       
