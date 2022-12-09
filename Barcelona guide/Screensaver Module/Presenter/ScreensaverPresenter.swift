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
    
    init(view: ScreensaverProtocol, networkServiceUser: RequestsUserApiProtocol,networkServiceSetings: RequestsSetingsApiProtocol,networkServiceHashtag: RequestsHashtagApiProtocol,networkServiceObject: RequestsObjectsApiProtocol, ruter:RouterProtocol)
    func getData()
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
    
    required  init(view: ScreensaverProtocol, networkServiceUser: RequestsUserApiProtocol,networkServiceSetings: RequestsSetingsApiProtocol,networkServiceHashtag: RequestsHashtagApiProtocol,networkServiceObject: RequestsObjectsApiProtocol, ruter:RouterProtocol){
        self.view = view
        self.router = ruter
        self.networkServiceUser = networkServiceUser
        self.networkServiceSetings = networkServiceSetings
        self.networkServiceHashtag = networkServiceHashtag
        self.networkServiceObject = networkServiceObject
        
        verificationUser()
    }
    
    func getData(){
        let meQueue = DispatchQueue(label: "getData")
      
        meQueue.sync {
            print("getUser-1")
        }
        meQueue.sync {
            print("getSetings-2")
            
        }
        meQueue.sync {
            print("getHashtag-3")
        }
        meQueue.sync {
            print("getObject-4")
            
        }
        meQueue.sync {
            print("dismis view")
            print("go to next page")
        }
    }
    func verificationUser(){
       
        networkServiceUser.verificationUser { [weak self] result in
            guard self != nil else {return}
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                    self?.getData()
                case .failure(let error):
                    self?.view?.failure(error: error)
                    self?.router?.dismiss()
                }
            }
        }
    }

    // Geting data
 //   func getData(){
 //       networkService.getData(user: self.user){ [weak self] result in
 //           guard self != nil else {return}
 //           DispatchQueue.main.async {
 //               switch result{
 //               case .success(let price):
 //                   self?.price = price?.sorted{$0.nameServise<$1.nameServise}
 //                   self?.view?.sucses(price: price)
 //                   self?.view?.reload()
 //               case .failure(let error):
 //                   self?.view?.failure(error: error)
 //
 //               }
 //           }
 //       }
 //   }
  
}

