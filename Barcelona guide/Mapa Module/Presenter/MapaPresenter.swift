//
//  MapaPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

protocol MapaProtocol: AnyObject{
    func failure(error: Error)
    func alert(title: String, message: String)
    func setUser(user: User)
}

protocol MapaPresenterProtocol: AnyObject{
    
    init(view: MapaProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol)
    func getData()
    var user: User? {get set}
    func openSettingsUser()
    func goToCollectionLocation()
}

class MapaPresenter: MapaPresenterProtocol{
    
    weak var view: MapaProtocol?
    let networkService: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    var user: User? {
        didSet {
         print("User chenging!")
            guard user != nil else{return}
            self.view?.setUser(user: user!)
        }
    }
    
    required init(view: MapaProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkService = networkService
        
        getData()
    }
    func goToCollectionLocation(){
        print("User collectionLoc!")
        self.router?.showCollectionLocations()
    }
    func openSettingsUser(){
        self.router?.showSettings()
    }
    
    // Geting data
    func getData(){
        self.user = userCache
    }
}
