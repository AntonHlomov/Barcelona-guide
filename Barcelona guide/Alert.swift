//
//  Alert.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 27/12/2021.
//

import UIKit

extension UIViewController{
    
    func alertAddAdress(title: String, placeholder: String, compleationHandler: @escaping (String) -> Void) {
        
        let alertControler = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default){ (action) in
            
            let textFieldsText = alertControler.textFields?.first
            guard let text = textFieldsText?.text else {return}
            compleationHandler(text)
            
        }
        
        alertControler.addTextField{ (tf) in
            tf.placeholder = placeholder
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            
        }
        
        alertControler.addAction(alertOk)
        alertControler.addAction(alertCancel)
        
        present(alertControler, animated: true, completion: nil)
        
    }
    
    func alertError(title: String, message: String){
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        alertControler.addAction(alertOk)
        present(alertControler, animated: true, completion: nil)
        
    }
    
   
    
}

