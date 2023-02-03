//
//  MapAndFooterPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2023.
//

import Foundation
import CoreLocation
import MapKit


protocol AdvertisementProtocol: AnyObject{
    func failure(error: Error)
    }

protocol ViewHeaderProtocol: AnyObject{
    func failure(error: Error)
    }

protocol MapRouteProtocol: AnyObject{
    func schowPointObjects(coordinatePoint: CLLocationCoordinate2D, scale: Double)

    
    func openHeader(shouldMove: Bool)
    func closeViewFX()
    func failure(error: Error)
    }

protocol FotterProtocol: AnyObject{
    func corectionYfotter(headerMove: Bool,fotterMove: Bool)
    func openFotter(fotterMove: Bool, headerMove: Bool)
    func failure(error: Error)
    }

protocol MapAndFooterPresenterProtocol: AnyObject{
    
    init(viewHeader:ViewHeaderProtocol,viewAdvertisement: AdvertisementProtocol,viewFotter: FotterProtocol,viewMapRoute: MapRouteProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol, user: User?, object: Object?)
    func toggleFotter()
    func toggleHeader()
    func handlersTapMapa()
    func clouseView()
    func openAllMenu()
    
    func selectorTookButton()
    func selectorCancelButton()
    
    func menuConecter(index: IndexPath,indexMode: Int?)

    }
    
class MapAndFooterPresenter: MapAndFooterPresenterProtocol{
    
    weak var viewFotter: FotterProtocol?
    weak var viewMapRoute: MapRouteProtocol?
    weak var viewAdvertisement: AdvertisementProtocol?
    weak var viewHeader: ViewHeaderProtocol?
    let networkService: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    var user: User?
    var object: Object?
    var isMoveFooter = false
    var isMoveHeader = false {
        didSet{
            self.viewFotter?.corectionYfotter(headerMove: isMoveHeader, fotterMove: isMoveFooter)
        }
    }
  
    
    required init(viewHeader:ViewHeaderProtocol,viewAdvertisement: AdvertisementProtocol,viewFotter: FotterProtocol,viewMapRoute: MapRouteProtocol, networkService: RequestsObjectsApiProtocol, router:RouterProtocol, user: User?, object: Object?){
        self.viewAdvertisement = viewAdvertisement
        self.viewFotter = viewFotter
        self.viewMapRoute = viewMapRoute
        self.viewHeader = viewHeader
        self.router = router
        self.networkService = networkService
        self.user = user
        self.object = object
        
        schowPoint()
        
    }
    //MARK: - Menu
    func menuConecter(index: IndexPath,indexMode: Int?){
        switch index.row{
        case 0://Messendger
          //  toggleMenu()
          //  self.router?.showChatUsers(user: self.user)
            return
        case 1: //StyleMode
            return
        case 2://MapMode
            guard let indexButoon = indexMode else {return}
          //  changeStyleMap(indexButoon: indexButoon)
            return
        case 3://RoadMode
            guard let indexButoon = indexMode else {return}
         //   changeTansportType(indexButonMode: indexButoon)
            return
        case 4://Location magnet
            guard let indexButoon = indexMode else {return}
           // self.viewMapa?.selectLocationMagnet(indexButonMode: indexButoon)
            return
        default:
            break
        }
    }
 
    func schowPoint(){
        guard let coordinate = self.object?.coordinate else {return}
        self.viewMapRoute?.schowPointObjects(coordinatePoint: coordinate, scale: 10)
    }
    
    func openAllMenu(){
        toggleFotter()
        toggleHeader()
    }
    func selectorTookButton() {
        print("selectorTookButton")
    }
    
    func selectorCancelButton() {
        self.viewMapRoute?.closeViewFX()
       
    }
    func clouseView(){
        //self.router?.initalScreensaver()
       self.router?.initContainerMapAndMenu()
        
    }
    func toggleHeader() {
        self.isMoveHeader = !self.isMoveHeader
        self.viewMapRoute?.openHeader(shouldMove: self.isMoveHeader)
    }
    func toggleFotter() {
        self.isMoveFooter = !self.isMoveFooter
        self.viewFotter?.openFotter(fotterMove: self.isMoveFooter, headerMove: self.isMoveHeader)
    }
    func handlersTapMapa() {
        switch self.isMoveFooter{
        case true:
            return
        case false:
            toggleFotter()
    
        }
    }
   
}

