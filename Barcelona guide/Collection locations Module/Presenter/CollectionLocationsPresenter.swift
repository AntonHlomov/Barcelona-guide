//
//  CollectionLocationsPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

protocol CollectionLocationsProtocol: AnyObject{
    func failure(error: Error)
    func alert(title: String, message: String)
}

protocol CollectionLocationsPresenterProtocol: AnyObject{
    
    init(view: CollectionLocationsProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol)
    func getData()
}

class CollectionLocationsPresenter: CollectionLocationsPresenterProtocol{
    
    weak var view: CollectionLocationsProtocol?
    let networkService: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    
    required init(view: CollectionLocationsProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkService = networkService
        
        getData()
    }
    
    // Geting data
    func getData(){
    }
}
