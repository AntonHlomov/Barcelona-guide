//
//  RegistrationPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import UIKit

protocol RegistrationProtocol: AnyObject{
    func failure(error: Error)
    func alert(title: String, message: String)
}

protocol RegistrationPresenterProtocol: AnyObject{
    
    init(view: RegistrationProtocol, networkService: RegistrationApiProtocol, router:RouterProtocol)
    func goToLoginControler()
    func setRegistrationInformation(photoUser: UIImage, emailAuth: String, name: String, passwordAuth: String)
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
    func setRegistrationInformation(photoUser: UIImage, emailAuth: String, name: String, passwordAuth: String){
        networkService.registration(photoUser: photoUser, emailAuth: emailAuth, name: name, passwordAuth: passwordAuth){[weak self] result in
            guard let self = self else {return}
                DispatchQueue.main.async {
                    switch result{
                    case.success(_):
                        self.router?.initalScreensaver()
                    case.failure(let error):
                        self.view?.failure(error: error)
                    }
                }
            }
    }
    func goToLoginControler(){
        self.router?.schowLoginMoveToLeft()
    }
    
    // Geting data
    func setData(){
    }
}
