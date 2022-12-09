//
//  FavoriteObjectsPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

protocol FavoriteObjectsProtocol: AnyObject{
    
    func sucses(objects: [Object]?)
    func failure(error: Error)
    func reload()
    func reloadCell(indexPath: IndexPath)
    func alert(title: String, message: String)
}

protocol FavoriteObjectsPresenterProtocol: AnyObject{
    
    init(view: FavoriteObjectsProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol)
    var objects: [Object]? {get set}
    func getData()
}

class FavoriteObjectsPresenter: FavoriteObjectsPresenterProtocol{
    
    weak var view: FavoriteObjectsProtocol?
    let networkService: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    var objects: [Object]?
  
    
    required init(view: FavoriteObjectsProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkService = networkService

        getData()
    }
    
    // Geting data
    func getData(){
   
    }
    
}

