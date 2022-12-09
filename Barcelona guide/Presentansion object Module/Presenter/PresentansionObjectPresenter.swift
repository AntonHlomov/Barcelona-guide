//
//  PresentansionObjectPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 09/12/2022.
//

import Foundation

protocol PresentansionObjectProtocol: AnyObject{
    
    func failure(error: Error)
    func reload()
    func alert(title: String, message: String)
}

protocol PresentansionObjectPresenterProtocol: AnyObject{
    
    init(view: PresentansionObjectProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol, user: User?)
    var user: User? {get set}
}

class PresentansionObjectPresenter: PresentansionObjectPresenterProtocol{
    
    weak var view: PresentansionObjectProtocol?
    let networkService: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    var user: User?
    
    required init(view: PresentansionObjectProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol, user: User?){
        self.view = view
        self.router = router
        self.networkService = networkService
        self.user = user
        
        getData()
    }
    
    // Geting data
    func getData(){
    
    }
}
