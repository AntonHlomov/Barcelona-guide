//
//  ScreensaverPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

protocol ScreensaverProtocol: AnyObject{
    func failure(error: Error)
    func alert(title: String, message: String)
}

protocol ScreensaverPresenterProtocol: AnyObject{
    
    init(view: ScreensaverProtocol, networkServiceUser: RequestsUserApiProtocol,networkServiceSetings: RequestsSetingsApiProtocol,networkServiceHashtag: RequestsHashtagApiProtocol,networkServiceObject: RequestsObjectsApiProtocol, router:RouterProtocol)
    func verificationUser()
}

class ScreensaverPresenter: ScreensaverPresenterProtocol{
 
    
    
    weak var view: ScreensaverProtocol?
    let networkServiceUser: RequestsUserApiProtocol!
    let networkServiceSetings: RequestsSetingsApiProtocol!
    let networkServiceHashtag: RequestsHashtagApiProtocol!
    let networkServiceObject: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    var user: User?
    var setings: Setings?
    var hashtag: [Hashtag]?
    var object: [Object]?
    
    required  init(view: ScreensaverProtocol, networkServiceUser: RequestsUserApiProtocol,networkServiceSetings: RequestsSetingsApiProtocol,networkServiceHashtag: RequestsHashtagApiProtocol,networkServiceObject: RequestsObjectsApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkServiceUser = networkServiceUser
        self.networkServiceSetings = networkServiceSetings
        self.networkServiceHashtag = networkServiceHashtag
        self.networkServiceObject = networkServiceObject

        verificationUser()
    }
    
    func verificationUser(){
        DispatchQueue.main.async { [self] in
            networkServiceUser.verificationUser { [weak self] result in
                guard self != nil else {return}
                switch result{
                case .success(_):
                    self?.getData()
                case .failure(_):
                    sleep(3)
                    print("authorization false")
                    self?.router?.initalLogin()
                    self?.router?.dismiss()
                }
            }
        }
    }
    
    func getData(){
        let meQueue = DispatchQueue(label: "getData")
  
        meQueue.sync {
            self.networkServiceUser.getUser{[weak self] result in
            guard let self = self else {return}
                    switch result{
                    case.success(let user):
                        self.user = user
                    case.failure(let error):
                        self.view?.failure(error: error)
               }
            }
            print("getUser")
       }
        meQueue.sync {
            sleep(1)
            print("getData-2")
            
        }
        meQueue.sync {
            sleep(2)
            print("getData-3")
        }
        meQueue.sync {
            sleep(1)
            print("getData-4")
            
        }
        meQueue.sync {
            DispatchQueue.main.async { [self] in
                self.router?.initalMapa()
                self.router?.dismiss()
            }
        }
    }
    func getUser(){
        DispatchQueue.main.async {
            self.networkServiceUser.getUser{[weak self] result in
            guard let self = self else {return}
                    switch result{
                    case.success(let user):
                        self.user = user
                    case.failure(let error):
                        self.view?.failure(error: error)
               }
            }
         }
    }
    
    
    
    
    
    
    
}
