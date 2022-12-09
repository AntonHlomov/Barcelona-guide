//
//  LoginPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

protocol LoginProtocol: AnyObject{
    func failure(error: Error)
    func alert(title: String, message: String)
}

protocol LoginPresenterProtocol: AnyObject{
    
    init(view: LoginProtocol, networkService: LoginApiProtocol, router:RouterProtocol)
    func getData()
}

class LoginPresenter: LoginPresenterProtocol{
    
    weak var view: LoginProtocol?
    let networkService: LoginApiProtocol!
    var router: RouterProtocol?
    
    required init(view: LoginProtocol, networkService: LoginApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkService = networkService
        
        getData()
    }
    
    // Geting data
    func getData(){
    }
}

