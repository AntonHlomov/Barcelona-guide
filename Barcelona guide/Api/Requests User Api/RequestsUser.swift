//
//  RequestsUser.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import Firebase

protocol RequestsUserApiProtocol {
    func verificationUser(completion: @escaping (Result<Bool,Error>) -> Void)
}
class RequestsUserApi: RequestsUserApiProtocol{
   
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
                       
