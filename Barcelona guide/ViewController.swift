//
//  ViewController.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 27/12/2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
   
    fileprivate let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let locationManager = CLLocationManager()
    var annotationsArray = [MKPointAnnotation]()
    var lastAnotation = MKPointAnnotation()
    var ferstAnotation = MKPointAnnotation()
    let annotationUser = MKPointAnnotation()
    
    
    fileprivate let firstPlaceTextfield = UITextField.setupTextField(title: "First place..", hideText: false, enabled: true)
    
    fileprivate let lastPlaceTextField = UITextField.setupTextField(title: "Last place..", hideText: false, enabled: true)
    
    fileprivate let locationButtonAdFirstPlace = UIButton.setupButtonImage(color: .lightGray,activation: true,invisibility: false, laeyerRadius: 6, alpha: 0.2,resourseNa: "icons8-pinMap-48")
    
    fileprivate let locationButtonAdLastPlace = UIButton.setupButtonImage(color: .lightGray,activation: true,invisibility: false, laeyerRadius: 6, alpha: 0.2,resourseNa: "icons8-pinMap-48")
    
    fileprivate let addAdressButton = UIButton.setupButton(title: "+", color: UIColor.rgb(red: 31, green: 152, blue: 233),activation: true,invisibility: false, laeyerRadius: 30/2, alpha: 0.5)
    
    fileprivate let styleMap = UIButton.setupButtonImage( color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false, laeyerRadius: 40/2, alpha: 0.7, resourseNa: "icons8-map-24")
    
    fileprivate let styleCarOrWhalk = UIButton.setupButtonImage( color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false, laeyerRadius: 40/2, alpha: 0.7, resourseNa: "icons8-whalk-30")
    
    fileprivate let addYorRouteButton = UIButton.setupButtonImage( color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false, laeyerRadius: 50/2, alpha: 0.8,resourseNa: "icons8-add-100")
    
    fileprivate let userLocationButtonCircle = UIButton.setupButtonImage(color: UIColor.rgb(red: 31, green: 152, blue: 233),activation: true,invisibility: false, laeyerRadius: 50/2, alpha: 0.6,resourseNa: "icons8-gps-30")
    
    fileprivate let routeButton = UIButton.setupButton(title: "Route", color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false, laeyerRadius: 30/2, alpha: 1)
    
    fileprivate let resetButton = UIButton.setupButton(title: "Reset", color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false, laeyerRadius: 30/2, alpha: 1)
   
    lazy var stackTextFieldView = UIStackView(arrangedSubviews: [firstPlaceTextfield,lastPlaceTextField])
    lazy var stackButtonMapCarWhalk = UIStackView(arrangedSubviews: [styleMap,styleCarOrWhalk])
    lazy var circleButtonView = UIStackView(arrangedSubviews: [userLocationButtonCircle,addYorRouteButton])
    lazy var stackButtonView = UIStackView(arrangedSubviews: [routeButton,resetButton])
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        OnOflocationManager()
        hadleres()
        configureViewComponents()
        setupTapGesture()
        
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        configureViewComponents()
    }

    func OnOflocationManager(){
        
        if CLLocationManager.locationServicesEnabled() {
              locationManager.delegate = self
              locationManager.desiredAccuracy = kCLLocationAccuracyBest
          }
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        annotationUser.coordinate = locValue
        annotationUser.title = "Anton khlomov"
        annotationUser.subtitle = "current location"
        
    }
    
    fileprivate func configureViewComponents(){
       
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))

        stackTextFieldView.axis = .vertical
        stackTextFieldView.spacing = 50
        stackTextFieldView.distribution = .fillEqually  // для корректного отображения
        
        view.addSubview(stackTextFieldView)
        stackTextFieldView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 10, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 130))
        
        view.addSubview(addAdressButton)
        addAdressButton.anchor(top: firstPlaceTextfield.bottomAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 30, height: 30))
        addAdressButton.centerXAnchor.constraint(equalTo: stackTextFieldView.centerXAnchor).isActive = true //выстовляет по середине экрана
        
        
        view.addSubview(locationButtonAdFirstPlace)
        locationButtonAdFirstPlace.anchor(top: firstPlaceTextfield.topAnchor, leading: nil, bottom: firstPlaceTextfield.bottomAnchor, trailing: firstPlaceTextfield.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: -0.1), size: .init(width: firstPlaceTextfield.frame.height, height: 0))

        view.addSubview(locationButtonAdLastPlace)
        locationButtonAdLastPlace.anchor(top: lastPlaceTextField.topAnchor, leading: nil, bottom: lastPlaceTextField.bottomAnchor, trailing: lastPlaceTextField.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: -0.1), size: .init(width: lastPlaceTextField.frame.height, height: 0))
        
        stackButtonMapCarWhalk.axis = .vertical
        stackButtonMapCarWhalk.spacing = 10
        stackButtonMapCarWhalk.distribution = .fillEqually  // для корректного отображения
        
        view.addSubview(stackButtonMapCarWhalk)
        stackButtonMapCarWhalk.anchor(top: stackTextFieldView.bottomAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 20, left: 0, bottom: 0, right: 10), size: .init(width: 40, height: 90))

        stackButtonView.axis = .horizontal
        stackButtonView.spacing = 30
        stackButtonView.distribution = .fillEqually  // для корректного отображения
        
        view.addSubview(stackButtonView)
        stackButtonView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 10 , bottom: 0, right: 10), size: .init(width: 0, height: 0))
        
        circleButtonView.axis = .vertical
        circleButtonView.spacing = 15
        circleButtonView.distribution = .fillEqually  // для корректного отображения
        
        view.addSubview(circleButtonView)
        circleButtonView.anchor(top: nil, leading: nil, bottom: stackButtonView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0 , bottom: 35, right: 10), size: .init(width: 50, height: 115))
        
    }
    
    func hadleres(){
    
        firstPlaceTextfield.addTarget(self, action: #selector(formValidationFirst), for: .editingDidEnd )
        lastPlaceTextField.addTarget(self, action: #selector(formValidationLast), for: .editingDidEnd)
        locationButtonAdFirstPlace.tag = 0
        locationButtonAdFirstPlace.addTarget(self, action: #selector(addLocationUserFerstPlace(sender:)), for: .touchUpInside)
        locationButtonAdLastPlace.tag = 0
        locationButtonAdLastPlace.addTarget(self, action: #selector(addLocationUserLastPlace(sender:)), for: .touchUpInside)
        addAdressButton.addTarget(self, action: #selector(touchAddAdress), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(touchRouteButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(touchResetButton), for: .touchUpInside)
        styleMap.addTarget(self, action: #selector(changeStyleMap), for: .touchUpInside)
        userLocationButtonCircle.tag = 0
        userLocationButtonCircle.addTarget(self, action: #selector(locationUser(sender:)), for: .touchUpInside)
        styleCarOrWhalk.tag = 0
        styleCarOrWhalk.addTarget(self, action: #selector(changeCarOrWhalk(sender:)), for: .touchUpInside)
    
    }
    
    // проверяем поля на заполненность
    @objc fileprivate func formValidationFirst() {
        guard
           firstPlaceTextfield.hasText
        else {
            mapView.removeAnnotation(ferstAnotation)
            mapView.removeOverlays(mapView.overlays)
            ferstAnotation = MKPointAnnotation()
            return
        }
        guard let first = firstPlaceTextfield.text else {return}
        setupPlacemark(adressPlace: first, mark: "ferstText")
    }
   
    // проверяем поля на заполненность
    @objc fileprivate func formValidationLast() {
        guard
            lastPlaceTextField.hasText
        else {
            mapView.removeAnnotation(lastAnotation)
            mapView.removeOverlays(mapView.overlays)
            lastAnotation = MKPointAnnotation()
            return
        }
       
        guard let second = lastPlaceTextField.text else {return}
        setupPlacemark(adressPlace: second, mark: "lastPlace")
    }

    @objc fileprivate func touchAddAdress(){
        alertAddAdress(title: "Add one more place", placeholder: "Add adres") {  [self] (text) in
        // получаем текст из алерта  отпраляем его в функцию и получаем анатацию и точки на карте
            setupPlacemark(adressPlace: text, mark: "additionPlace")
        }
      
    }
    
    @objc fileprivate func touchRouteButton(){
       
        guard
            ferstAnotation.coordinate as NSObject != CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) as NSObject &&
                lastAnotation.coordinate as NSObject != CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) as NSObject
        else { alertError(title: "Oops", message: "Indicate at least two places.")
               return }
        
        mapView.removeOverlays(mapView.overlays)
        let showArrayAnnotions = [ferstAnotation] + annotationsArray + [lastAnotation]
        
        for index in 0...showArrayAnnotions.count - 2{
            createDirectioReqest(startCoordinate: showArrayAnnotions[index].coordinate, destinationCoordinate: showArrayAnnotions[index + 1].coordinate)
        }
        mapView.showAnnotations(showArrayAnnotions, animated: true)
    }
    
    @objc fileprivate func touchResetButton(){
        
        lastAnotation = MKPointAnnotation()
        ferstAnotation = MKPointAnnotation()
        firstPlaceTextfield.text = ""
        lastPlaceTextField.text = ""
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
     
    }
    
    @objc fileprivate func changeStyleMap(){
        
        switch mapView.mapType {
        case .standard:
            mapView.mapType = .satellite
        case .satellite:
            mapView.mapType = .hybrid
        case .hybrid:
            mapView.mapType = .satelliteFlyover
        case .satelliteFlyover:
            mapView.mapType = .hybridFlyover
        case .hybridFlyover:
            mapView.mapType = .mutedStandard
        case .mutedStandard:
            mapView.mapType = .standard
        @unknown default:
            mapView.mapType = .standard
        }

    }
    
    @objc fileprivate func addLocationUserFerstPlace(sender: UIButton){
     
       switch sender.tag {
       case 0:
           if locationButtonAdLastPlace.tag == 1 {
               addLocationUserLastPlace(sender: locationButtonAdLastPlace)
           }
           
           locationManager.startMonitoringSignificantLocationChanges()
           if ferstAnotation != annotationUser {
               mapView.removeAnnotation(ferstAnotation)
               mapView.removeOverlays(mapView.overlays)
           }
           ferstAnotation = annotationUser
           locationButtonAdFirstPlace.backgroundColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.4)
           firstPlaceTextfield.text = ""
           firstPlaceTextfield.placeholder = "Your location.."
           mapView.showAnnotations([ferstAnotation], animated: true)
           locationButtonAdFirstPlace.tag = 1
           
       case 1:
           firstPlaceTextfield.placeholder = "First place.."
           ferstAnotation = MKPointAnnotation()
           mapView.removeAnnotation(annotationUser)
           mapView.removeOverlays(mapView.overlays)
           locationButtonAdFirstPlace.backgroundColor = .lightGray.withAlphaComponent(0.2)
           locationButtonAdFirstPlace.tag = 0
           
       default:
           return
       }
     }
   
    @objc fileprivate func addLocationUserLastPlace(sender: UIButton){
        
        switch sender.tag {
        case 0:
            if locationButtonAdFirstPlace.tag == 1 {
                addLocationUserFerstPlace(sender: locationButtonAdFirstPlace)
            }
            
            locationManager.startMonitoringSignificantLocationChanges()
            if lastAnotation != annotationUser {
                mapView.removeAnnotation(lastAnotation)
                mapView.removeOverlays(mapView.overlays)
            }
            lastAnotation = annotationUser
            locationButtonAdLastPlace.backgroundColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.4)
            lastPlaceTextField.text = ""
            lastPlaceTextField.placeholder = "Your location.."
            mapView.showAnnotations([lastAnotation], animated: true)
            locationButtonAdLastPlace.tag = 1
            
        case 1:
            lastPlaceTextField.placeholder = "Last place.."
            lastAnotation = MKPointAnnotation()
            mapView.removeAnnotation(annotationUser)
            mapView.removeOverlays(mapView.overlays)
            locationButtonAdLastPlace.backgroundColor = .lightGray.withAlphaComponent(0.2)
            locationButtonAdLastPlace.tag = 0
            
        default:
            return
        }
     }
    
   @objc fileprivate func locationUser(sender: UIButton){
        
       switch sender.tag  {
       case 0:
           locationManager.startUpdatingLocation()
           userLocationButtonCircle.tag = 1
           userLocationButtonCircle.backgroundColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.6)
          
       case 1:
           locationManager.stopUpdatingLocation()
           userLocationButtonCircle.tag = 0
           userLocationButtonCircle.backgroundColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.6)
       default:
           return
       }
    }
  
    @objc fileprivate func changeCarOrWhalk(sender: UIButton){
        guard
            ferstAnotation.coordinate as NSObject != CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) as NSObject &&
            lastAnotation.coordinate as NSObject != CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) as NSObject
        else { alertError(title: "Oops", message: "Indicate at least two places.")
               return }

       switch sender.tag {
       case 0:
           styleCarOrWhalk.tag = 1
           styleCarOrWhalk.setImage(#imageLiteral(resourceName: "icons8-автомобиль-90"), for:.normal)
           styleCarOrWhalk.backgroundColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.6)
           touchRouteButton()
       case 1:
           styleCarOrWhalk.tag = 0
           styleCarOrWhalk.setImage(#imageLiteral(resourceName: "icons8-whalk-30"), for:.normal)
           styleCarOrWhalk.backgroundColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.6)
           touchRouteButton()
       default:
           return
       }
        
     }
  
    //MARK: - put point for map.
    private func  setupPlacemark(adressPlace: String, mark: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressPlace) { [self] (placemarks, error) in
            if let error = error{
                print(error.localizedDescription)
                alertError(title: "Error", message: "Server error, please try again.")
                return
            }
            
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            
            let anotation = MKPointAnnotation()
            anotation.title = "\(adressPlace)"
            
            guard let placemarkLocation = placemark?.location else {return}
            anotation.coordinate = placemarkLocation.coordinate
            
            switch mark{
            case "ferstText" :
                if ferstAnotation != anotation {
                    mapView.removeAnnotation(ferstAnotation)
                    mapView.removeOverlays(mapView.overlays)
                }
                 ferstAnotation = anotation
                 mapView.showAnnotations([ferstAnotation], animated: true)
                
            case "additionPlace":
                annotationsArray.append(anotation)
                mapView.showAnnotations(annotationsArray, animated: true)
                
            case "lastPlace":
                if lastAnotation != anotation {
                    mapView.removeAnnotation(lastAnotation)
                    mapView.removeOverlays(mapView.overlays)
                }
                lastAnotation = anotation
                mapView.showAnnotations([lastAnotation], animated: true)
             default:
                return
            }
        }
    }
      
    //MARK: - let's make a route for point.
    private func createDirectioReqest (startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D){
      
        
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        // запрос
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)

        switch styleCarOrWhalk.tag {
        case 0:
            request.transportType = .walking
        case 1:
            request.transportType = .automobile
         
        default:
            return
        }
        
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
            self.mapView.addOverlay(minRoute.polyline)
            
        }
    }
    //MARK: - TapGesture and endEditing
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
      
    }
    @objc fileprivate func handleTapDismiss(){
        view.endEditing(true)
    }
}

//MARK: - extension

extension ViewController: MKMapViewDelegate{
    
    // отрисовка на карте маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        switch styleCarOrWhalk.tag {
        case 0:
            render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.7)
        case 1:
            render.strokeColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.7)
       
        default:
            render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196)
        }
        
        return render
    }
    
    
 
    
  
    
}

