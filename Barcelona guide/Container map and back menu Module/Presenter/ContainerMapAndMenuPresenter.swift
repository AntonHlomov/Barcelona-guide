//
//  ContainerMapAndMenuPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 19/12/2022.
//

import Foundation
import CoreLocation
import MapKit

protocol ContainerMapProtocol: AnyObject{
    func failure(error: Error)
}

protocol MenuViewProtocol: AnyObject{
    func setDataButtonMenu(indexPath: IndexPath) // ??
}

protocol MapProtocol: AnyObject{
    // DATA
    func setDataUserButton(user: User?)
    func setObjects(objects: [Object])
    func getLastLocationUser() // ??
    func schowPointObjects(coordinatePoint: CLLocationCoordinate2D, scale: Double)
    func schowPointUser(coordinatePoint: CLLocationCoordinate2D)
    func drawRoute(route: MKOverlay, distance: String, timeRoute: String)
    func removeRoute()
    func selectAnatacionObject(object: Object)
    // MENU
    func openMenu(shouldMove: Bool)
    func openViewMassege(open: Bool)
    func styleMap(mapStayle: MKMapType)
    func tansportType(tipe: MKDirectionsTransportType)
    func selectLocationMagnet(indexButonMode: Int)
    // ERROR
    func failure(error: Error)
    func sucsesReloadDataCV()
}

protocol ContainerMapAndMenuPresenterProtocol: AnyObject{
    init(view: ContainerMapProtocol,viewMapa:MapProtocol,viewMenuMapa:MenuViewProtocol,networkService: RequestsObjectsApiProtocol, router:RouterProtocol)
    // MAPA DATA
  //  var user: User? {get set}
  //  var favoritOjects: [Object]? {get set}
  //  var nearbysObjects: [Object]? {get set}
 //   var lastLocationUsert: CLLocationCoordinate2D? {get set}
    
  //  func showLocationUser()
    
    // MENU
   // func getUser()
    func setUser()
    func toggleMenu()
    func getObjects()
    func handlersTapMapa() // Closed menu wen we taped for map.
    func menuConecter(index: IndexPath,indexMode: Int?)
    
    // MAPA BUTTON
    func showUser()
    func addNewOject()
    func showCollectionAllObgects()
    func putCellColectionObject(index: IndexPath)
    func createRout(objectCoordinate: CLLocationCoordinate2D)
    func schowObject(object: Object)
    func openViewMassegeAboutRoute(open: Bool)
    
  

}
    
class ContainerMapAndMenuPresenter: ContainerMapAndMenuPresenterProtocol{
    weak var view: ContainerMapProtocol?
    weak var viewMapa: MapProtocol?
    weak var viewMenuMapa: MenuViewProtocol?
    let networkService: RequestsObjectsApiProtocol!
    var router: RouterProtocol?
    
    var isMove: Bool // Indicator back menu close or open.
    var favoritOjects: [Object]?
    var nearbysObjects: [Object]?
    var lastLocationUsert: CLLocationCoordinate2D?
    var user: User?
    var timeRoute: Double?
    var distanseRoute: Double?
    var transportTypeMapa: MKDirectionsTransportType = .walking
    //  var user: User? { didSet { print("User chenging!"); setUser()} }
    required init(view: ContainerMapProtocol,viewMapa:MapProtocol,viewMenuMapa:MenuViewProtocol,networkService: RequestsObjectsApiProtocol, router:RouterProtocol){
        
        self.view = view
        self.viewMapa = viewMapa
        self.viewMenuMapa = viewMenuMapa
        self.router = router
        self.networkService = networkService
        self.user = userCache
        self.isMove = false // Indicator back menu closed
        self.favoritOjects = [Object]()
        self.nearbysObjects = [Object]()
        
        setUser()
        showUser()
        
    }
    //MARK: - Menu
    func menuConecter(index: IndexPath,indexMode: Int?){
        switch index.row{
        case 0://Profile
            return
        case 1://Messendger
            toggleMenu()
            self.router?.showChatUsers(user: self.user)
            return
        case 2: //StyleMode
            return
        case 3://MapMode
            guard let indexButoon = indexMode else {return}
            changeStyleMap(indexButoon: indexButoon)
            return
        case 4://RoadMode
            guard let indexButoon = indexMode else {return}
            changeTansportType(indexButonMode: indexButoon)
            return
        case 5://Location magnet
            guard let indexButoon = indexMode else {return}
            self.viewMapa?.selectLocationMagnet(indexButonMode: indexButoon)
            return
        default:
            break
        }
    }
    //MARK: - Style map
    func changeStyleMap(indexButoon: Int){
        switch indexButoon {
        case 0:
            self.viewMapa?.styleMap(mapStayle: MKMapType.standard)
        case 1:
            self.viewMapa?.styleMap(mapStayle: MKMapType.satellite)
        case 2:
            self.viewMapa?.styleMap(mapStayle: MKMapType.hybrid)
        case 3:
            self.viewMapa?.styleMap(mapStayle: MKMapType.satelliteFlyover)
        case 4:
            self.viewMapa?.styleMap(mapStayle: MKMapType.hybridFlyover)
        case 5:
            self.viewMapa?.styleMap(mapStayle: MKMapType.mutedStandard)
        default:
            self.viewMapa?.styleMap(mapStayle: MKMapType.standard)
        }
    }
    //MARK: - Tansport type for map
    func changeTansportType(indexButonMode: Int){
        switch indexButonMode {
        case 0:
            self.transportTypeMapa = .walking
            self.viewMapa?.tansportType(tipe: MKDirectionsTransportType.walking)
        case 1:
            self.transportTypeMapa = .automobile
            self.viewMapa?.tansportType(tipe: MKDirectionsTransportType.automobile)
        default:
            self.transportTypeMapa = .walking
            self.viewMapa?.tansportType(tipe: MKDirectionsTransportType.walking)
        }
    }
    //MARK: - Show location user
    func showUser(){
        let coordinateUser = CLLocationManager()
        guard let coordinateUser = coordinateUser.location?.coordinate else {return}
        self.viewMapa?.schowPointUser(coordinatePoint: coordinateUser)
    }
    
    func setUser(){
        guard user != nil else{return}
        self.viewMapa?.setDataUserButton(user: user!)
    }
    //MARK: - Get objects
    func getObjects(){
        let dist = 50 * 1000
        let coordinateUser = CLLocationManager()
        guard let coordinateUser = coordinateUser.location?.coordinate else {return}
        networkService.getObjectsNearUser(user: self.user, radius: Double(dist), locationUser: coordinateUser) { [weak self] result in
            guard self != nil else {return}
            DispatchQueue.main.async { [self] in
                switch result{
                case .success(let objects):
                    self?.nearbysObjects?.removeAll()
                    self?.nearbysObjects = objects
                    self?.viewMapa?.setObjects(objects: self?.nearbysObjects ?? [Object]())
                    self?.viewMapa?.sucsesReloadDataCV()
                    print("success getObjects")
                case .failure(let error):
                    self?.view?.failure(error: error)
                }
            }
        }
    }
    
    // MARK: Button map
    func openViewMassegeAboutRoute(open: Bool){
        // open view massage
        //   self.viewMapa?.openViewMassege(open: true)
    }
    
    func showCollectionAllObgects(){
        print("User collectionLoc!")
        self.router?.showCollectionLocations()
    }
    func toggleMenu() {
        self.isMove = !self.isMove
        self.viewMapa?.openMenu(shouldMove:self.isMove)
    }
    func handlersTapMapa() {
        switch self.isMove{
        case true:
            toggleMenu()
        case false:
            self.viewMapa?.removeRoute()
            // clouse view massage
            //  self.viewMapa?.openViewMassege(open: false)
        }
    }
    func addNewOject(){
        self.router?.showAddNewOject(user: self.user)
    }
    //MARK: - make a route to objects.
    
    func putCellColectionObject(index: IndexPath){
        guard let object = nearbysObjects?[index.row] else {return}
        guard let coordinate = nearbysObjects?[index.row].coordinate else {return}
        self.viewMapa?.schowPointObjects(coordinatePoint: coordinate, scale: 75)
        let coordinateUser = CLLocationManager()
        guard let coordinateUser = coordinateUser.location?.coordinate else {return}
        createDirectioReqest(userCoordinate: coordinateUser, objectCoordinate: coordinate)
        self.viewMapa?.selectAnatacionObject(object: object)
    }
    func createRout(objectCoordinate: CLLocationCoordinate2D){
        let coordinateUser = CLLocationManager()
        guard let coordinateUser = coordinateUser.location?.coordinate else {return}
        createDirectioReqest(userCoordinate: coordinateUser, objectCoordinate: objectCoordinate)
    }
    
    func createDirectioReqest (userCoordinate: CLLocationCoordinate2D, objectCoordinate: CLLocationCoordinate2D){
        let startLocation = MKPlacemark(coordinate: userCoordinate)
        let destinationLocation = MKPlacemark(coordinate: objectCoordinate)
        
        // запрос
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = transportTypeMapa
        // смотрим альтернативные маршруты
        request.requestsAlternateRoutes = true
        let direction = MKDirections(request: request)
        direction.calculate { (responce, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let responce = responce else {
                // self.alertError(title: "Error", message: "Route not available.")
                return
            }
            
            // route.distance показывает дистанцию маршрута в метрах
            // responce.routes маршруты но мы берем первый, что бы в дальнейшем в цикле сравнивать какой короче
            var minRoute = responce.routes[0]
            for route in responce.routes {
                minRoute = (route.distance < minRoute.distance) ? route : minRoute
            }
            self.distanseRoute = minRoute.distance/1000
            var distanseRoute = String(self.distanseRoute ?? 0.0)   //route.distance //показывает дистанцию маршрута в метрах
            distanseRoute.removeLast(2)
            self.timeRoute = minRoute.expectedTravelTime/60
            var time = String(format: "%.0f", self.timeRoute ?? 0.0)
            // создаем маршрут
            self.viewMapa?.drawRoute(route: minRoute.polyline, distance: distanseRoute, timeRoute:  time)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1050)) {
            // open view massage
            // self.viewMapa?.openViewMassege(open: true)
            self.viewMapa?.openViewMassege(open: true)
        }
    }
    func schowObject(object: Object){
        self.router?.showPresentansionObject(user: self.user, object: object,distanseRoute: self.distanseRoute ?? 0.0,timeRoute: self.timeRoute ?? 0.0 )
    }
    
    func getAnotations(){
        //let annotation4 = MKPointAnnotation()
        //   annotation4.coordinate = CLLocationCoordinate2D(latitude:41.410422846823855, longitude:  //2.154067881398437)
        //   annotation4.title = "Мебель" // Optional
        //   annotation4.subtitle = "Красивый стул " // Optional
        //   nearbysObjects.append(annotation4)
        //   self.viewMapa?.showAnatansions(anatansions: self.nearbysObjects)
    }
    
    
}
