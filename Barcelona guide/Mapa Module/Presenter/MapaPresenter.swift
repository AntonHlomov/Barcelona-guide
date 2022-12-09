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
}

protocol MapaPresenterProtocol: AnyObject{
    
    init(view: MapaProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol)
    func getData()
}

class MapaPresenter: MapaPresenterProtocol{
    
    weak var view: MapaProtocol?
    let networkService: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    
    required init(view: MapaProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkService = networkService
        
        getData()
    }
    
    // Geting data
    func getData(){
    }
}
