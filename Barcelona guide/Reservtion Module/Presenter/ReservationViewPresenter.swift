//
//  ReservationViewPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 05/01/2023.
//

import Foundation

protocol ReservationViewProtocol: AnyObject{
    func setTime(timeRoute: String)
    func failure(error: Error)
    }

protocol ReservationViewPresenterProtocol: AnyObject{
    
    init(view: ReservationViewProtocol, networkService: ApiReservationProtocol, router: RouterProtocol, user: User?, distance: Double, timeRoute: Double,object:Object?)
    func setData()
    func targetMaybeLater()
    func targetReservation()
    }
    
class ReservationViewPresenter: ReservationViewPresenterProtocol{
   
    weak var view: ReservationViewProtocol?
    let networkService: ApiReservationProtocol!
    var router: RouterProtocol?
    var object: Object?
    var user: User?
    var distance: Double
    var timeRoute: Double
    

    required init(view: ReservationViewProtocol, networkService: ApiReservationProtocol, router:RouterProtocol, user: User?, distance: Double, timeRoute: Double,object:Object?){
        self.view = view
        self.router = router
        self.networkService = networkService
        self.user = user
        self.object = object
        self.distance = distance
        self.timeRoute = timeRoute
        setTime()
    }
    func targetReservation(){
        self.router?.initalMapAndFooterModule(user: user, object: self.object)
    }
    func setTime(){
        let time = String(format: "%.0f", self.timeRoute)
        self.view?.setTime(timeRoute: time)
    }
    func targetMaybeLater(){
        self.router?.popToRoot()
    }

    // Upload data
    func setData(){
        /*     guard let setData = self.price?[indexPath.row] {return}
        networkService.setData(user: self.user, price: setData){ [weak self] result in
            guard self != nil else {return}
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                    self?.view?.reload()
                    self?.view?.alert(title: "The upload.", message: "The upload was successful.")
                case .failure(let error):
                    self?.view?.failure(error: error)
                  
                }
            }
        }*/
    }

}

