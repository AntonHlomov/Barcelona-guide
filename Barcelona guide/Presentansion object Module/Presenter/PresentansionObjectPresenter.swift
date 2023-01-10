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
    func setObjectData(object: Object, distans:String, time:String)
  
}

protocol PresentansionObjectPresenterProtocol: AnyObject{
    
    init(view: PresentansionObjectProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol, user: User?, object: Object,distanseRoute: Double,timeRoute: Double)
    var user: User? {get set}
    func backToMap()
    func sendMassege()
    func makeReservation()
}

class PresentansionObjectPresenter: PresentansionObjectPresenterProtocol{
    
    weak var view: PresentansionObjectProtocol?
    let networkService: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    var user: User?
    var object: Object
    var distanseRoute: Double
    var timeRoute: Double
    
    required init(view: PresentansionObjectProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol, user: User?,object: Object,distanseRoute: Double,timeRoute: Double){
        self.view = view
        self.router = router
        self.networkService = networkService
        self.user = user
        self.object = object
        self.distanseRoute = distanseRoute
        self.timeRoute = timeRoute
        
        setObjectData(object: self.object)
    }
    func backToMap(){
        self.router?.popToRoot()
    }
    func setObjectData(object: Object){
        var distanseRoute = String(self.distanseRoute)   //route.distance //показывает дистанцию маршрута в метрах
        distanseRoute.removeLast(2)
        let time = String(format: "%.0f", self.timeRoute)
        self.view?.setObjectData(object: object, distans:distanseRoute, time:time)
    }
    func sendMassege(){
        self.router?.showMessenger()
    }
    func makeReservation(){
        self.router?.showReservation(user: self.user, object: self.object, distanseRoute: self.distanseRoute, timeRoute: self.timeRoute)
    }

    // Geting data
    func getData(){
    
    }
}
