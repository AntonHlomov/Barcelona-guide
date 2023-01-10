//
//  RequestsForLogin.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import Firebase

protocol LoginApiProtocol {
    func login(emailAuth: String, passwordAuth: String,completion: @escaping (Result<Bool,Error>) -> Void)
}
class LoginApi: LoginApiProtocol{
    func login(emailAuth: String, passwordAuth: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: emailAuth, password: passwordAuth) { (user, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
    
}
