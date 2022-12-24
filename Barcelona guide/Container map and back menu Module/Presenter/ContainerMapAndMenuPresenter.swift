//
//  ContainerMapAndMenuPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 19/12/2022.
//

import Foundation
import MapKit

protocol ContainerMapProtocol: AnyObject{
    func failure(error: Error)
}

protocol MenuViewProtocol: AnyObject{
    func setDataButtonMenu(indexPath: IndexPath)
}

protocol MapProtocol: AnyObject{
    // DATA
    func setDataUserButton(user: User)
    func showAnatansions(anatansions: [Object])
    // MENU
    func openMenu(shouldMove: Bool)
    
    func changeStyleMap(indexButoon: Int)
    func changeTansportType(indexButonMode: Int)
    func selectLocationMagnet(indexButonMode: Int)
    // ERROR
    func failure(error: Error)
}

protocol ContainerMapAndMenuPresenterProtocol: AnyObject{
    init(view: ContainerMapProtocol,viewMapa:MapProtocol,viewMenuMapa:MenuViewProtocol,networkService: RequestsObjectsApiProtocol, router:RouterProtocol)
    // MAPA DATA
    var user: User? {get set}
    var favoritOjects: [Object]? {get set}
    // MENU
    func getUser()
    func setUser()
    func toggleMenu()
    func getObjects()
    func toggleMenuOnlyClouse() // Closed menu wen we taped for map.
    func menuConecter(index: IndexPath,indexMode: Int?)
    
    // MAPA BUTTON
    func addNewOject()
    func showCollectionAllObgects()
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
    
    var user: User? { didSet { print("User chenging!"); setUser()}
        
    }
    
    required init(view: ContainerMapProtocol,viewMapa:MapProtocol,viewMenuMapa:MenuViewProtocol,networkService: RequestsObjectsApiProtocol, router:RouterProtocol){
        
        self.view = view
        self.viewMapa = viewMapa
        self.viewMenuMapa = viewMenuMapa
        self.router = router
        self.networkService = networkService
        
        self.isMove = false // Indicator back menu closed
        self.favoritOjects = [Object]()
        self.nearbysObjects = [Object]()
       
        getUser()
        getObjects()
    }
    // Geting data
    func getUser(){
        print("Geting data")
        self.user = userCache
    }
    func setUser(){
        guard user != nil else{return}
        self.viewMapa?.setDataUserButton(user: user!)
    }
    func getObjects(){
        let lat = 41.410422846823855
        let long = 2.154067881398437
        let dist = 50 * 1000
        networkService.getObjectsNearUser(user: self.user, radius: Double(dist), latitudeUser: lat, longitudeUser: long) { [weak self] result in
            guard self != nil else {return}
            DispatchQueue.main.async { [self] in
                switch result{
                case .success(let objects):
                    self?.nearbysObjects = objects
                    self?.viewMapa?.showAnatansions(anatansions: self?.nearbysObjects ?? [Object]() )
                    print("success")
                case .failure(let error):
                    self?.view?.failure(error: error)
                  
                }
            }
        }
    }
    
    func getAnotations(){
       //let annotation4 = MKPointAnnotation()
     //   annotation4.coordinate = CLLocationCoordinate2D(latitude:41.410422846823855, longitude:  //2.154067881398437)
     //   annotation4.title = "Мебель" // Optional
     //   annotation4.subtitle = "Красивый стул " // Optional
     //   nearbysObjects.append(annotation4)
     //   self.viewMapa?.showAnatansions(anatansions: self.nearbysObjects)
    }
    func addNewOject(){
        self.router?.showAddNewOject(user: self.user)
    }
    // MARK: Button map
    func showCollectionAllObgects(){
        print("User collectionLoc!")
        self.router?.showCollectionLocations()
    }
    //MARK: Menu
    
    func toggleMenu() {
        self.isMove = !self.isMove
        self.viewMapa?.openMenu(shouldMove:self.isMove)
    }
    func toggleMenuOnlyClouse() {
        guard self.isMove == true else {return}
        self.isMove = !self.isMove
        self.viewMapa?.openMenu(shouldMove:self.isMove)
    }
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
            self.viewMapa?.changeStyleMap(indexButoon: indexButoon)
            return
        case 4://RoadMode
            guard let indexButoon = indexMode else {return}
            self.viewMapa?.changeTansportType(indexButonMode: indexButoon)
            return
        case 5://Location
            guard let indexButoon = indexMode else {return}
            self.viewMapa?.selectLocationMagnet(indexButonMode: indexButoon)
           // toggleMenu()
            return
        
        default:
            break
        }
        
    }
    
}
