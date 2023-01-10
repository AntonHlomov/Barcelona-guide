//
//  RequestsCategory.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import Firebase

var categoryCash = [Category]()
protocol RequestsCategoryApiProtocol {
    func getCategory(completion: @escaping (Result<[Category]?,Error>) -> Void)
    
}
class RequestsCategoryApi: RequestsCategoryApiProtocol{
    func getCategory(completion: @escaping (Result<[Category]?, Error>) -> Void) {
        guard (Auth.auth().currentUser?.uid) != nil else {return}
        let db =  Firestore.firestore().collection("category")
        db.addSnapshotListener{ (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            categoryCash.removeAll()
            snapshot?.documents.forEach({ (documentSnapshot) in
                let categoryDictionary = documentSnapshot.data()
                let category = Category(dictionary: categoryDictionary)
                categoryCash.append(category)
            })
            completion(.success(categoryCash))
        }
    }
    
}
