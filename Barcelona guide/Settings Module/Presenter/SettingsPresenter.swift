//
//  SettingsPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

protocol SettingsProtocol: AnyObject{
    func failure(error: Error)
    func alert(title: String, message: String)
}

protocol SettingsPresenterProtocol: AnyObject{
    
    init(view: SettingsProtocol, networkService: RequestsSetingsApiProtocol, router:RouterProtocol)
    func getData()
    func goToBack()
}

class SettingsPresenter: SettingsPresenterProtocol{
    
    weak var view: SettingsProtocol?
    let networkService: RequestsSetingsApiProtocol!
    var router: RouterProtocol?
    
    required init(view: SettingsProtocol, networkService: RequestsSetingsApiProtocol, router:RouterProtocol){
        self.view = view
        self.router = router
        self.networkService = networkService
        
        getData()
    }
    func goToBack() {
        self.router?.backTappedFromRight()
    }
    // Geting data
    func getData(){
    }
}
