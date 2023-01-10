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

class Mapa: UIViewController,UINavigationControllerDelegate{
    var presenter: ContainerMapAndMenuPresenterProtocol!
    var map = MKMapView()
    var appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: 135)
        layout.sectionInset = UIEdgeInsets(top: 25, left: 10, bottom: 3, right: 10)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var user: User?
    var obgects = [Object]()
    let annotationUser = MKPointAnnotation()
    var objectsForRoude = [Object]()
    var locationManager: CLLocationManager!
    var transportTypeMapa: MKDirectionsTransportType = .walking
    
  
    //MARK: - Buttons
    var massegeView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.bluePewter)?.withAlphaComponent(0.7)
     
        return view
    }()
    lazy var walk: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-булавка-для-карты-24").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var walkLabel = UILabel.setupLabel(title: "1.5", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    let kmWalkLabel = UILabel.setupLabel(title: "km", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    lazy var stackWKLabel = UIStackView(arrangedSubviews: [walkLabel,kmWalkLabel])
    lazy var stackWalk = UIStackView(arrangedSubviews: [walk,stackWKLabel])
    
    lazy var time: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-время-48").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var timeLabel = UILabel.setupLabel(title: "15", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    let horsTimeLabel = UILabel.setupLabel(title: "min", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    lazy var stackTHLabel = UIStackView(arrangedSubviews: [timeLabel,horsTimeLabel])
    lazy var stackTime = UIStackView(arrangedSubviews: [time,stackTHLabel])
    lazy var stackInformationRoute = UIStackView(arrangedSubviews: [stackWalk,stackTime])
    
    var userImageButton = CustomUIimageView(frame: .zero )
    fileprivate let showUserLocation = UIButton.setupButtonImage( color: UIColor.appColor(.bluePewter)!,activation: true,invisibility: false, laeyerRadius: 12, alpha:0.6,resourseNa: "icons8-центральное-направление-50")
    fileprivate let showColectionObjects = UIButton.setupButtonImage( color: UIColor.appColor(.bluePewter)!,activation: true,invisibility: false, laeyerRadius: 12, alpha:0.6,resourseNa: "menu")
    fileprivate let addNewObjectButton = UIButton.setupButtonImage( color: UIColor.appColor(.pinkLightSalmon)!,activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "add")
    lazy var stackButtons = UIStackView(arrangedSubviews: [showUserLocation,showColectionObjects,addNewObjectButton])
    
    //MARK: - View did load, will appear.
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
     
        map.showsUserLocation = true
        colecnionDelegate()
        configureViewComponents()
        targetButtons()
        setupTapGestureMap()
        presenter.getObjects()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Configure view components
    func configureViewComponents(){
        view.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        map.layer.cornerRadius = 12
        
        view.addSubview(massegeView)
        massegeView.anchor(top:  view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, pading: .init(top: 30, left: 0, bottom: 0, right: -view.frame.width/2), size: .init(width: view.frame.width/2, height: 50))
        massegeView.layer.cornerRadius = 12
    
        stackWKLabel.axis = .horizontal
        stackWalk.spacing = 0
        stackWKLabel.distribution = .fillEqually
        
        stackWalk.axis = .horizontal
        stackWalk.spacing = 0
        stackWalk.distribution = .fillEqually
        
        stackTHLabel.axis = .horizontal
        stackWalk.spacing = 0
        stackTHLabel.distribution = .fillEqually
        
        stackTime.axis = .horizontal
        stackTime.spacing = 0
        stackTime.distribution = .fillEqually
        
        stackInformationRoute.axis = .horizontal
        stackInformationRoute.spacing = 0
        stackInformationRoute.distribution = .fillEqually
        
        massegeView.addSubview(stackInformationRoute)
        stackInformationRoute.anchor(top: massegeView.topAnchor, leading: massegeView.leadingAnchor, bottom: nil, trailing: massegeView.trailingAnchor, pading: .init(top: 15, left: 0, bottom: 5, right: 10), size: .init(width: 0, height: 23))
        
        view.addSubview(userImageButton)
        userImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 30, left: 20, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        userImageButton.layer.cornerRadius = 70/2
        userImageButton.layer.borderWidth = 3
        userImageButton.layer.borderColor = UIColor.appColor(.bluePewter)!.cgColor
        
        view.addSubview(appsCollectionView)
        appsCollectionView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/5))
        
        stackButtons.axis = .vertical
        stackButtons.spacing = 15
        stackButtons.distribution = .fillEqually
        view.addSubview(stackButtons)
        stackButtons.anchor(top: nil, leading: nil, bottom: appsCollectionView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0 , bottom: 50, right:-12), size: .init(width: 80, height: 180))
    }
    func targetButtons(){
        let tapUserImage = UITapGestureRecognizer(target: self, action: #selector(Mapa.selectorUserButton))
        userImageButton.addGestureRecognizer(tapUserImage)
        userImageButton.isUserInteractionEnabled = true
        showUserLocation.addTarget(self, action: #selector(selectorshowUserLocation), for: .touchUpInside)
        showColectionObjects.addTarget(self, action: #selector(selectorShowColectionObjects), for: .touchUpInside)
        
        addNewObjectButton.tag = 0
        addNewObjectButton.addTarget(self, action: #selector(selectorAddNewObjectButton(sender:)), for: .touchUpInside)
    }
    func colecnionDelegate(){
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        appsCollectionView.register(CellObectsFavorit.self, forCellWithReuseIdentifier: cellId)
    }
    //MARK: - Selector buttons
    @objc fileprivate func selectorShowColectionObjects(){
        presenter.showCollectionAllObgects()
    }
    @objc fileprivate func selectorUserButton(){
        presenter.toggleMenu()
    }
    @objc fileprivate func selectorAddNewObjectButton(sender: UIButton){
        presenter?.addNewOject()
    }
    @objc fileprivate func selectorshowUserLocation(sender: UIButton){
        presenter?.showUser()
    }
    @objc fileprivate func selectorImagePoint(_ sender: PassableUIButton){
        guard let objectPoint = sender.params["objectPointValue"] as? Object else {return}
        print("selectorImagePoint")
        presenter.schowObject(object: objectPoint )
    }
    
    //MARK: - TapGesture and endEditing
    fileprivate func setupTapGestureMap(){
        map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closedMenu)))
    }
    @objc fileprivate func closedMenu(){
        presenter.handlersTapMapa() // taped for map.
      //  view.endEditing(true)
    }
  
}
//MARK: - Extension map
extension Mapa: CLLocationManagerDelegate {

    // iOS 14
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("Not determined")
            case .restricted:
                print("Restricted")
            case .denied:
                print("Denied")
            case .authorizedAlways:
                print("Authorized Always")
            case .authorizedWhenInUse:
                print("Authorized When in Use")
            @unknown default:
                print("Unknown status")
            }
        }
    }
    
    // iOS 13 and below
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("Authorized Always")
        case .authorizedWhenInUse:
            print("Authorized When in Use")
        @unknown default:
            print("Unknown status")
        }
    }
}

//MARK: - MKMapViewDelegate
extension Mapa: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {return}
        guard let pin = view.annotation as? Object else {return}
        presenter.createRout(objectCoordinate: pin.coordinate)
       // presenter.openViewMassegeAboutRoute(open: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is Object) {return nil}
        let id = MKMapViewDefaultAnnotationViewReuseIdentifier
        
        // Balloon Shape Pin (iOS 11 and above)
        if let view = map.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
            view.titleVisibility = .visible // Set Title to be always visible
            view.subtitleVisibility = .visible // Set Subtitle to be always visible
            view.markerTintColor = .clear//UIColor.appColor(.bluePewter)  // Background color of the balloon shape pin
            let cpa = annotation as! Object
            lazy var imageView = CustomUIimageView(frame: .zero)
            imageView.loadImage(with: cpa.objectImage ?? "")
            lazy var imageUser = CustomUIimageView(frame: .zero)
            imageUser.loadImage(with: cpa.profileImageUserСreator ?? "")
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
            view.titleVisibility = .visible // Set Title to be always visible
            view.subtitleVisibility = .visible // Set Subtitle to be always visible
            view.markerTintColor = .yellow // Background color of the balloon shape pin
            view.glyphImage = ObjectUIImagePoint(image: imageView.image?.circleMasked)
           // view.largeContentImage = imageView.image?.circleMasked
            view.frame.size = CGSize(width: 80, height: 80)
            
            let objectButtonPoint = PassableUIButton(frame: CGRect(origin: CGPoint.zero,size: CGSize(width: 48, height: 55)))
            //objectButtonPoint.layer.cornerRadius = 12
            objectButtonPoint.setBackgroundImage(imageView.image, for: .normal)
            view.rightCalloutAccessoryView = objectButtonPoint
            objectButtonPoint.addTarget(self, action:  #selector(Mapa.selectorImagePoint(_:)), for: .touchDown)
            objectButtonPoint.params["objectPointValue"] = cpa
            
            let objectButtonPointLeft = PassableUIButton(frame: CGRect(origin: CGPoint.zero,size: CGSize(width: 45, height: 45)))
            objectButtonPointLeft.layer.cornerRadius = 45/2
            objectButtonPointLeft.setBackgroundImage(imageUser.image?.circleMasked, for: .normal)
            view.leftCalloutAccessoryView = objectButtonPointLeft
           // objectButtonPointLeft.addTarget(self, action:  #selector(Mapa.selectorImagePoint(_:)), for: .touchDown)
           // objectButtonPointLeft.params["objectPointValue"] = cpa
            return view
        }
        
        // Classic old Pin (iOS 10 and below)
        if let view = map.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView {
            // Customize only the 'Example 0' Pin
            if annotation.title == "Example 0" {
                view.animatesDrop = true // Animates the pin when shows up
                view.pinTintColor = UIColor.appColor(.bluePewter) // The color of the head of the pin
                view.canShowCallout = true // When you tap, it shows a bubble with the title and the subtitle
                return view
            }
        }
        
        return nil
    }
    
    // отрисовка на карте маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.lineWidth = 4.5
        switch transportTypeMapa {
        case .walking:
            render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.7)
        case .automobile:
            render.strokeColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.7)
            
        default:
            render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196)
        }
        return render
    }
}
//MARK: - Extension MapProtocol
extension Mapa: MapProtocol {
   
    
    func setDataUserButton(user: User?) {
        self.user = user
        userImageButton.loadImage(with: user?.profileImageUser ?? "")
    }
    func setObjects(objects: [Object]) {
        self.obgects = objects
        self.map.addAnnotations(obgects)
        self.map.showAnnotations(obgects, animated: true)
    }
    
    func getLastLocationUser() {
        
    }
    func schowPointUser(coordinatePoint: CLLocationCoordinate2D) {
        annotationUser.coordinate = coordinatePoint
        annotationUser.title = self.user?.nameUser
        self.map.addAnnotation(annotationUser)
        self.map.setCenter(coordinatePoint, animated: true)
        self.map.showAnnotations([annotationUser], animated: true)
    }
    
    func schowPointObjects(coordinatePoint: CLLocationCoordinate2D, scale: Double) {
        let scaleMeters: CLLocationDistance = scale
        let region = MKCoordinateRegion(center: coordinatePoint, latitudinalMeters: scaleMeters, longitudinalMeters: scaleMeters)
        self.map.setRegion(region, animated: true)
    }
    
    func openMenu(shouldMove: Bool) {
        switch shouldMove{
        case true :
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.view.frame.origin.x = self.view.frame.width - 140
            }) { (finished) in }
        case false:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.view.frame.origin.x = 0
            }) { (finished) in }
        }
    }
    
    func openViewMassege(open: Bool) {
        switch open{
        case true :

            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.massegeView.frame.origin.x = self.view.frame.width - (self.view.frame.width/2) - 20
            }) { (finished) in }
        case false:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.massegeView.frame.origin.x = self.view.frame.width+5
            }) { (finished) in }
        }
    }
    
    func tansportType(tipe: MKDirectionsTransportType){
        transportTypeMapa = tipe
    }
    func styleMap(mapStayle: MKMapType){
        map.mapType = mapStayle
    }
    
    func selectLocationMagnet(indexButonMode: Int) {
        
    }
    
    func failure(error: Error) {
        
    }
    
    func sucsesReloadDataCV() {
       appsCollectionView.reloadData()
    }
    func drawRoute(route: MKOverlay, distance: String, timeRoute: String){
        self.walkLabel.text = distance
        self.timeLabel.text = timeRoute
        // remove route
        self.map.removeOverlays(map.overlays)
        // add route
        self.map.addOverlay(route)
       // map.showAnnotations(obgects, animated: true)
    }
    func removeRoute(){
        // remove route
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) {
            self.map.removeOverlays(self.map.overlays)
        }
    }
    func selectAnatacionObject(object: Object){
        self.map.selectAnnotation(object, animated: true)
    }
  
}
/*
class Mapa: UIViewController,UINavigationControllerDelegate{
    var presenter: ContainerMapAndMenuPresenterProtocol!
    
    var map = MKMapView()
    var transportTypeMapa: MKDirectionsTransportType = .walking
    var locationManager = CLLocationManager()  { didSet {  presenter?.lastLocationUsert = locationManager.location?.coordinate }}
    var annotationsArray = [MKPointAnnotation]()
    let annotationUser = MKPointAnnotation()
    
    var nameUser = ""
   // var selectObjectWithPoint: Object?
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 250, height: 135)
            layout.sectionInset = UIEdgeInsets(top: 25, left: 10, bottom: 3, right: 10)
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - Buttons
    var userImageButton = CustomUIimageView(frame: .zero )
    fileprivate let menu = UIButton.setupButtonImage( color: UIColor.appColor(.bluePewter)!,activation: true,invisibility: false, laeyerRadius: 12, alpha:0.6,resourseNa: "menu")
    fileprivate let addNewObjectButton = UIButton.setupButtonImage( color: UIColor.appColor(.pinkLightSalmon)!,activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "add")
    lazy var downRStackButton = UIStackView(arrangedSubviews: [menu,addNewObjectButton])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        locationManagerSetings()
        presenter.lastLocationUsert = self.locationManager.location?.coordinate
        configureViewComponents()
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        appsCollectionView.register(CellObectsFavorit.self, forCellWithReuseIdentifier: cellId)
        setupTapGesture()
        hadleres()
        presenter.getObjects()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
       // locationManager.startUpdatingLocation()
       // sleep(1)
       // locationManager.stopUpdatingLocation()
    }
    fileprivate func configureViewComponents(){
        view.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        view.addSubview(userImageButton)
        userImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 30, left: 20, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        userImageButton.layer.cornerRadius = 70/2
        
        view.addSubview(appsCollectionView)
        appsCollectionView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/5))
     
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
    //MARK: - Selector buttons
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
    
    
   
    @objc fileprivate func selectorImagePoint(_ sender: PassableUIButton){
        guard let objectPoint = sender.params["objectPointValue"] as? Object else {return}
        print("selectorImagePoint")
        presenter.schowObject(object: objectPoint )
    }
    
    func locationManagerSetings(){
        locationManager.requestWhenInUseAuthorization()
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
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locValue, span: span)
        annotationUser.coordinate = locValue
        annotationUser.title = nameUser
        //annotationUser.subtitle = "current location"
        self.map.addAnnotation(annotationUser)
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
//MARK: - Extension MKMapViewDelegate
extension Mapa: MKMapViewDelegate{
 //   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
 //           if !(annotation is Object) {
 //               return nil
 //           }
//
 //           let reuseId = "Location"
//
 //           var anView = map.dequeueReusableAnnotationView(withIdentifier: reuseId)
 //           if anView == nil {
 //               anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
 //               anView!.canShowCallout = true
 //           }
 //           else {
 //               anView!.annotation = annotation
 //           }
 //           let cpa = annotation as! Object
 //           let imageView = CustomUIimageView(frame: .zero)
 //           imageView.loadImage(with: cpa.objectImage)
 //           anView!.largeContentImage = imageView.image
 //
 //           return anView
 //       }
 
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is Object) {return nil}
        let id = MKMapViewDefaultAnnotationViewReuseIdentifier
        // Balloon Shape Pin (iOS 11 and above)
        if let view = map.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
               view.titleVisibility = .visible // Set Title to be always visible
               view.subtitleVisibility = .visible // Set Subtitle to be always visible
               view.markerTintColor = .clear//UIColor.appColor(.bluePewter)  // Background color of the balloon shape pin
            let cpa = annotation as! Object
            lazy var imageView = CustomUIimageView(frame: .zero)
            imageView.loadImage(with: cpa.objectImage ?? "")
            view.glyphImage = ObjectUIImagePoint(image: imageView.image)
            view.largeContentImage = imageView.image
            view.frame.size = CGSize(width: 60, height: 60);
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let objectButtonPoint = PassableUIButton(frame: CGRect(origin: CGPoint.zero,size: CGSize(width: 48, height: 48)))
            objectButtonPoint.setBackgroundImage(imageView.image, for: .normal)
            view.rightCalloutAccessoryView = objectButtonPoint
            objectButtonPoint.addTarget(self, action:  #selector(Mapa.selectorImagePoint(_:)), for: .touchDown)
            objectButtonPoint.params["objectPointValue"] = cpa
            return view
        }
            
        // Classic old Pin (iOS 10 and below)
        if let view = map.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView {
            // Customize only the 'Example 0' Pin
            if annotation.title == "Example 0" {
                view.animatesDrop = true // Animates the pin when shows up
                view.pinTintColor = UIColor.appColor(.bluePewter) // The color of the head of the pin
                view.canShowCallout = true // When you tap, it shows a bubble with the title and the subtitle
                return view
            }
        }
                    
        return nil
    }

}
//MARK: - Extension CLLocationManagerDelegate
extension Mapa: CLLocationManagerDelegate {
    
    // iOS 14
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("Not determined")
            case .restricted:
                print("Restricted")
            case .denied:
                print("Denied")
            case .authorizedAlways:
                print("Authorized Always")
            case .authorizedWhenInUse:
                print("Authorized When in Use")
            @unknown default:
                print("Unknown status")
            }
        }
    }
    
    // iOS 13 and below
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("Authorized Always")
        case .authorizedWhenInUse:
            print("Authorized When in Use")
        @unknown default:
            print("Unknown status")
        }
    }
}
//MARK: - Extension MapProtocol
extension Mapa: MapProtocol {
    func schowPointEnMap(coordinatePoint: CLLocationCoordinate2D, scale: Double){
        let scaleMeters: CLLocationDistance = scale
        let region = MKCoordinateRegion(center: coordinatePoint, latitudinalMeters: scaleMeters, longitudinalMeters: scaleMeters)
        self.map.setRegion(region, animated: true)
    }
    
    func getLastLocationUser(){
    //    var loc =  self.locationManager.location?.coordinate
    }
    
    func setAnatansionsInMap(anatansions: [Object]){
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
    func tansportType(tipe: MKDirectionsTransportType){
        transportTypeMapa = tipe
    }
    func styleMap(mapStayle: MKMapType){
        map.mapType = mapStayle
    }

    func openMenu(shouldMove: Bool) {
        switch shouldMove{
        case true :
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.view.frame.origin.x = self.view.frame.width - 140
            }) { (finished) in }
        case false:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.view.frame.origin.x = 0
            }) { (finished) in }
        }
    }
    
    func sucsesReloadDataCV() {
        appsCollectionView.reloadData()
    }
    
    func setDataUserButton(user: User?) {
        userImageButton.loadImage(with: user?.profileImageUser ?? "")
        userImageButton.layer.borderWidth = 3
        userImageButton.layer.borderColor = UIColor.appColor(.bluePewter)!.cgColor
     //   guard let name = user?.nameUser  else {return}
     //   guard let fullName = user?.fullNameUser else {return}
     //   self.nameUser = name + " " + fullName
                
    }
    func failure(error: Error){
        
    }
    func alert(title: String, message: String){
        
    }
}
*/
