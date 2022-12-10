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
    func authorisation(emailAuth: String, passwordAuth: String)
    func goToRegistarasionControler()
    func goToRegistrationWithApple()
}

class LoginPresenter: LoginPresenterProtocol{
    
    weak var view: LoginProtocol?
    let networkService: LoginApiProtocol!
    var router: RouterProtocol?
    
    required init(view: LoginProtocol, networkService: LoginApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkService = networkService
        
    }
    func goToRegistrationWithApple(){
        print("goToRegistrationWithApple")
    }
    func authorisation(emailAuth: String, passwordAuth: String){
        networkService.login(emailAuth: emailAuth, passwordAuth: passwordAuth) {[weak self] result in
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
    func goToRegistarasionControler(){
        self.router?.showRegistration()
    }
}
