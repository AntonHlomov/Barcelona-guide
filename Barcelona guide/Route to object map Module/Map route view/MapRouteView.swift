//
//  MapRouteView.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2023.
//

import UIKit
import MapKit
import CoreLocation


class MapRouteView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var presenter: MapAndFooterPresenterProtocol!
    
    var mapView = MKMapView()
    var locationManager: CLLocationManager!
    let annotationUser = MKPointAnnotation()
    let annotationObject = MKPointAnnotation()
    var transportTypeMapa: MKDirectionsTransportType = .walking
    var timeRoute: Double?
    var distanseRoute: Double?
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        view.backgroundColor = .clear
        configurationView()
        setupTapGestureupButoonFon()
        mapView.showsUserLocation = true
        //concentration for all annotations
        mapView.showAnnotations(mapView.annotations, animated: true)
    

    }
    func configurationView(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 55, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        mapView.layer.cornerRadius = view.frame.width/8
        
        view.addSubview(upButoon)
        upButoon.anchor(top: mapView.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 70, height: 5))
        upButoon.layer.cornerRadius = 2.5
        upButoon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(upButoonFon)
        upButoonFon.anchor(top: mapView.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 125, height: 35))
        upButoonFon.layer.cornerRadius = 12
        upButoonFon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    //MARK: - TapGesture and endEditing
    fileprivate func setupTapGestureupButoonFon(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeMorDown))
            swipeDown.direction = .down
            self.view.addGestureRecognizer(swipeDown)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeMorUp))
        swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
        upButoonFon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleHeader)))
    }
    @objc fileprivate func toggleHeader(){
        presenter.toggleHeader()
    }
    @objc fileprivate func swipeMorUp(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            if  self.view.frame.origin.y == 70 {
                self.presenter.toggleHeader()
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
                self.presenter.toggleHeader()
               // self.view.frame.origin.y = 70//self.view.frame.height - self.view.frame.height
            }else {
                self.view.frame.origin.y = self.view.frame.height/2 - 30 //self.view.frame.height - self.view.frame.height
            }
        }) { (finished) in }
    }

}
extension MapRouteView{
    
    public func centerMapWithBottom(bottomPadding: CGFloat) {
        mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0)
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
    func createDirectioReqest (userCoordinate: CLLocationCoordinate2D, objectCoordinate: CLLocationCoordinate2D){
        let startLocation = MKPlacemark(coordinate: userCoordinate)
        let destinationLocation = MKPlacemark(coordinate: objectCoordinate)
        
        
        // запрос
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking   //transportTypeMapa
        // смотрим альтернативные маршруты
        request.requestsAlternateRoutes = true
        let direction = MKDirections(request: request)
        direction.calculate { [weak self] (responce, error) in
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
            self?.distanseRoute = minRoute.distance/1000
            var distanseRoute = String(self?.distanseRoute ?? 0.0)   //route.distance //показывает дистанцию маршрута в метрах
            distanseRoute.removeLast(2)
            self?.timeRoute = minRoute.expectedTravelTime/60
            let time = String(format: "%.0f", self?.timeRoute ?? 0.0)
            // создаем маршрут
            // remove route
            guard let overLas = self?.mapView.overlays else {return}
            self?.mapView.removeOverlays(overLas)
            // add route
            self?.mapView.addOverlay( minRoute.polyline)
            
        }
       
    }
    
}

extension MapRouteView: MapRouteProtocol{
  
    func schowPointObjects(coordinatePoint: CLLocationCoordinate2D, scale: Double) {
        let coordinateUser = CLLocationManager()
        guard let coordinate = coordinateUser.location?.coordinate else {return}
        annotationUser.coordinate = coordinate
        annotationObject.coordinate = coordinatePoint
        self.mapView.addAnnotation(annotationUser)
        self.mapView.showAnnotations([annotationUser,annotationObject], animated: true)
        mapView.showAnnotations(mapView.annotations, animated: true)
        centerMapWithBottom(bottomPadding: 300)
        createDirectioReqest(userCoordinate: coordinate, objectCoordinate: coordinatePoint)
    }
    
    func openHeader(shouldMove: Bool) {
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
    func closeViewFX(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.view.alpha = 0.0
        }) { (finished) in
            self.presenter.clouseView()
            self.view.removeFromSuperview()
        }
    }
    func failure(error: Error) {
    }
    
}
