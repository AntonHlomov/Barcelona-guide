//
//  SettingsPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation

protocol MessengerProtocol: AnyObject{
    func failure(error: Error)
    func alert(title: String, message: String)
}

protocol MessengerPresenterProtocol: AnyObject{
    
    init(view: MessengerProtocol, networkService: RequestsMessengerApiProtocol, router:RouterProtocol)
    func getData()
    func goToBack()
    var messenges: [Message]? {get set}
}

class MessengerPresenter: MessengerPresenterProtocol{
    
    weak var view: MessengerProtocol?
    let networkService: RequestsMessengerApiProtocol!
    var router: RouterProtocol?
    var messenges: [Message]?
    
    required init(view: MessengerProtocol, networkService: RequestsMessengerApiProtocol, router:RouterProtocol){
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
