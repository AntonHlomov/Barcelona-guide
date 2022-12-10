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
            sleep(4)
            print("getUser-1")
       }
        meQueue.sync {
            sleep(2)
            print("getSetings-2")
            
        }
        meQueue.sync {
            sleep(5)
            print("getHashtag-3")
        }
        meQueue.sync {
            sleep(1)
            print("getObject-4")
            
        }
        meQueue.sync {
            DispatchQueue.main.async { [self] in
                self.router?.initalMapa()
                self.router?.dismiss()
            }
        }
            
        
      
    }
}
