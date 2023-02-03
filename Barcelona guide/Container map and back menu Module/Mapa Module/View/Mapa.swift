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
    var upButoonFon: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    var upButoon: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayMidle)?.withAlphaComponent(0.8)
        return view
    }()
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
        presenter.toggleMenu()
    }
    
    //MARK: - Configure view components
    func configureViewComponents(){
        view.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 55, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        map.layer.cornerRadius = view.frame.width/8
        
        view.addSubview(upButoon)
        upButoon.anchor(top: map.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 70, height: 5))
        upButoon.layer.cornerRadius = 2.5
        upButoon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(upButoonFon)
        upButoonFon.anchor(top: map.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 125, height: 35))
        upButoonFon.layer.cornerRadius = 12
        upButoonFon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
        
  
        
        view.addSubview(appsCollectionView)
        appsCollectionView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/5))
        
        stackButtons.axis = .vertical
        stackButtons.spacing = 15
        stackButtons.distribution = .fillEqually
        view.addSubview(stackButtons)
        stackButtons.anchor(top: nil, leading: nil, bottom: appsCollectionView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0 , bottom: 50, right:-12), size: .init(width: 80, height: 180))
    }
    func targetButtons(){
     
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
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeMorDown))
            swipeDown.direction = .down
            self.view.addGestureRecognizer(swipeDown)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeMorUp))
        swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
        map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closedMenu)))
        upButoonFon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleHeader)))
    }
    @objc fileprivate func closedMenu(){
        presenter.handlersTapMapa() // taped for map.
      //  view.endEditing(true)
    }
    @objc fileprivate func toggleHeader(){
        presenter.toggleMenu()
    }
    @objc fileprivate func swipeMorUp(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            if  self.view.frame.origin.y == 70 {
                self.presenter.toggleMenu()
            }else {
                self.view.frame.origin.y = 70//self.view.frame.height - self.view.frame.height
            }
           
        }) { (finished) in }
    }
    @objc fileprivate func swipeMorDown(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            if  self.view.frame.origin.y == 0 {
                self.presenter.toggleMenu()
               // self.view.frame.origin.y = 70//self.view.frame.height - self.view.frame.height
            }else {
                self.view.frame.origin.y = self.view.frame.height/2 - 30 //self.view.frame.height - self.view.frame.height
            }
        }) { (finished) in }
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
            if annotation.title == "Example" {
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
                self.view.frame.origin.y = 70//self.view.frame.height - self.view.frame.height
            }) { (finished) in }
        case false:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.view.frame.origin.y = 0 //self.view.frame.height/7
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
