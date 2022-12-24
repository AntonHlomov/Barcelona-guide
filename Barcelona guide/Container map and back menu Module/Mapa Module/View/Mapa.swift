//
//  Mapa.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class Mapa: UIViewController,CLLocationManagerDelegate,UINavigationControllerDelegate,MKMapViewDelegate{
    var presenter: ContainerMapAndMenuPresenterProtocol!

    fileprivate let map: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    var transportTypeMapa: MKDirectionsTransportType = .walking
    let locationManager = CLLocationManager()
    var annotationsArray = [MKPointAnnotation]()
    let annotationUser = MKPointAnnotation()
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 200, height: 90)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var userImageButton = CustomUIimageView(frame: .zero )
    
    fileprivate let menu = UIButton.setupButtonImage( color: UIColor.appColor(.bluePewter)!,activation: true,invisibility: false, laeyerRadius: 12, alpha:0.6,resourseNa: "menu")
    
    
    fileprivate let addNewObjectButton = UIButton.setupButtonImage( color: UIColor.appColor(.pinkLightSalmon)!,activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "add")
    
    
    
    lazy var downRStackButton = UIStackView(arrangedSubviews: [menu,addNewObjectButton])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
      
        map.delegate = self
     //   locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManagerSetings()
        
        configureViewComponents()
        
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        appsCollectionView.register(CellObectsFavorit.self, forCellWithReuseIdentifier: cellId)
        
        setupTapGesture()
        hadleres()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        locationManager.startUpdatingLocation()
       // sleep(1)
        locationManager.stopUpdatingLocation()
    }
    fileprivate func configureViewComponents(){
        
        view.addSubview(map)
        map.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        view.addSubview(userImageButton)
        userImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 30, left: 20, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        userImageButton.layer.cornerRadius = 70/2
        
        
        view.addSubview(appsCollectionView)
        appsCollectionView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/6.2))
     
        downRStackButton.axis = .vertical
        downRStackButton.spacing = 15
        downRStackButton.distribution = .fillEqually
        view.addSubview(downRStackButton)
        downRStackButton.anchor(top: nil, leading: nil, bottom: appsCollectionView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0 , bottom: 50, right:-12), size: .init(width: 80, height: 110))
 
    }
    
    func hadleres(){
        let tapUserImage = UITapGestureRecognizer(target: self, action: #selector(Mapa.selectorUserButton))
        userImageButton.addGestureRecognizer(tapUserImage)
        userImageButton.isUserInteractionEnabled = true
        menu.addTarget(self, action: #selector(selectorMenu), for: .touchUpInside)
      
        addNewObjectButton.tag = 0
        addNewObjectButton.addTarget(self, action: #selector(selectorAddNewObjectButton(sender:)), for: .touchUpInside)
    }
    
    @objc fileprivate func selectorMenu(){
        print("selectorMenu")
        presenter.showCollectionAllObgects()
    }
    @objc fileprivate func selectorUserButton(){
        print("selectorUserButton")
        presenter.toggleMenu()
    }
  
    @objc fileprivate func selectorAddNewObjectButton(sender: UIButton){
        presenter?.addNewOject()
    }
    
    func locationManagerSetings(){
        if CLLocationManager.locationServicesEnabled() {
              locationManager.delegate = self
              locationManager.desiredAccuracy = kCLLocationAccuracyBest
          }
        map.delegate = self
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsUserLocation = true
        if let coor = map.userLocation.location?.coordinate{
            map.setCenter(coor, animated: true)
        }
    }
    //MARK: - make a route for point.
    private func createDirectioReqest (startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D){
        
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()// запрос
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
                self.alertError(title: "Error", message: "Route not available.")
                return
            }
            // route.distance показывает дистанцию маршрута в метрах
            // responce.routes маршруты но мы берем первый, что бы в дальнейшем в цикле сравнивать какой короче
            var minRoute = responce.routes[0]
            for route in responce.routes {
                minRoute = (route.distance < minRoute.distance) ? route : minRoute
            }
            // создаем маршрут
            self.map.addOverlay(minRoute.polyline)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: locValue, span: span)
       // annotationUser.coordinate = locValue
       // annotationUser.title = "Anton khlomov"
        //annotationUser.subtitle = "current location"
       // self.map.addAnnotation(annotationUser)
        map.setRegion(region, animated: true)
    }
    
    //MARK: - TapGesture and endEditing
    
  fileprivate func setupTapGesture(){
      map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
  }
  @objc fileprivate func handleTapDismiss(){
      presenter.toggleMenuOnlyClouse() // Closed menu wen we taped for map.
      view.endEditing(true)
  }


//MARK: - mapView
   
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.gray
            pinView?.canShowCallout = true
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
      
   

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is ObjectPointAnatasion {
            if let selectedAnnotation = view.annotation as? ObjectPointAnatasion {
                if let id = selectedAnnotation.identifier {
                    for pin in mapView.annotations as! [ObjectPointAnatasion] {
                        if let myIdentifier = pin.identifier {
                            if myIdentifier == id {
                                print(pin.lat ?? 0.0)
                                print(pin.lon ?? 0.0)
                               
                            }
                        }
                    }
                }
            }
        }
    }
*/
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect")
    }

    
    // отрисовка на карте маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        switch transportTypeMapa {
        case .walking:
            render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.7)
        case .automobile:
            render.strokeColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.7)
    
        default:
            render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196)
        }
        render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.7)
        return render
    }
}

extension Mapa: MapProtocol {
    
    func showAnatansions(anatansions: [Object]){
        self.map.addAnnotations(anatansions)
        self.map.showAnnotations(anatansions, animated: true)
    }
    
    func selectLocationMagnet(indexButonMode: Int){
        switch indexButonMode{
        case 0: locationManager.stopUpdatingLocation()
        case 1: locationManager.startUpdatingLocation()
        default: locationManager.stopUpdatingLocation()
        }
    }
 
    func changeTansportType(indexButonMode: Int){
        switch indexButonMode {
        case 0:
            transportTypeMapa = .walking
        case 1:
            transportTypeMapa = .automobile
        default:
            transportTypeMapa = .walking
        }
    }

    func changeStyleMap(indexButoon: Int){
        switch indexButoon {
        case 0:
            map.mapType = .standard
        case 1:
             map.mapType = .satellite
        case 2:
            map.mapType = .hybrid
        case 3:
            map.mapType = .satelliteFlyover
        case 4:
            map.mapType = .hybridFlyover
        case 5:
            map.mapType = .mutedStandard
       
        default:
            map.mapType = .standard
        }
    }
    
    func openMenu(shouldMove: Bool) {
        if shouldMove {
            // показываем menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.view.frame.origin.x = self.view.frame.width - 140
            }) { (finished) in
                
            }
        } else {
            // убираем menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.view.frame.origin.x = 0
            }) { (finished) in
                
            }
        }
    }
    
    func sucses() {
        print("sucses")
    }
    
    func setDataUserButton(user: User) {
        userImageButton.loadImage(with: user.profileImageUser ?? "")
        userImageButton.layer.borderWidth = 3
        userImageButton.layer.borderColor = UIColor.appColor(.bluePewter)!.cgColor
    }
    func failure(error: Error){
        
    }
    func alert(title: String, message: String){
        
    }
}
