//
//  RegistrationPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

protocol RegistrationProtocol: AnyObject{
    func failure(error: Error)
    func alert(title: String, message: String)
}

protocol RegistrationPresenterProtocol: AnyObject{
    
    init(view: RegistrationProtocol, networkService: RegistrationApiProtocol, router:RouterProtocol)
    func setData()
  
}

class RegistrationPresenter: RegistrationPresenterProtocol{
    
    weak var view: RegistrationProtocol?
    let networkService: RegistrationApiProtocol!
    var router: RouterProtocol?
    
    required init(view: RegistrationProtocol, networkService: RegistrationApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkService = networkService
        
        setData()
    }
    
    // Geting data
    func setData(){
    }
}
