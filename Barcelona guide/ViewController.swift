//
//  ViewController.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 27/12/2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    fileprivate let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
  
    
    fileprivate let firstPlaceTextfield = UITextField.setupTextField(title: "First place..", hideText: false)
    
    fileprivate let secondPlaceTextField = UITextField.setupTextField(title: "Second place..", hideText: false)
    
    lazy var stackTextFieldView = UIStackView(arrangedSubviews: [firstPlaceTextfield,secondPlaceTextField])
    // создание кнопку "Регистрация.."
    fileprivate let addAdressButton = UIButton.setupButton(title: "Add", color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false)
    // создание кнопку "Регистрация.."
    fileprivate let routeButton = UIButton.setupButton(title: "Route", color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false)
    // создание кнопку "Регистрация.."
    fileprivate let resetButton = UIButton.setupButton(title: "Reset", color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false)
    
    lazy var stackButtonView = UIStackView(arrangedSubviews: [addAdressButton,routeButton,resetButton])
    
    var annotationsArray = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        hadleres()
        configureViewComponents()
        setupTapGesture()
     
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        configureViewComponents()
    }
    
    
    fileprivate func configureViewComponents(){
       
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
    
        
        stackTextFieldView.axis = .vertical
        stackTextFieldView.spacing = 20
        stackTextFieldView.distribution = .fillEqually  // для корректного отображения
        
        view.addSubview(stackTextFieldView)
        stackTextFieldView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 10, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 100))
       // stackTextFieldView.centerXAnchor.constraint(equalTo: addresses.centerXAnchor).isActive = true //выстовляет по середине экрана
      //  stackTextFieldView.centerYAnchor.constraint(equalTo: addresses.centerYAnchor).isActive = true
        
        

        stackButtonView.axis = .horizontal
        stackButtonView.spacing = 30
        stackButtonView.distribution = .fillEqually  // для корректного отображения
        
        view.addSubview(stackButtonView)
        stackButtonView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 10 , bottom: 0, right: 10), size: .init(width: 0, height: 0))
        
    }
    
    // проверяем поля на заполненность
    func hadleres(){
    
        firstPlaceTextfield.addTarget(self, action: #selector(formValidation), for: .editingDidEnd )
        secondPlaceTextField.addTarget(self, action: #selector(formValidation), for: .editingDidEnd)
    
        addAdressButton.addTarget(self, action: #selector(touchAddAdress), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(touchRouteButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(touchResetButton), for: .touchUpInside)
    
    }
    
    
    
    // проверяем поля на заполненность
    @objc fileprivate func formValidation() {
        guard
            firstPlaceTextfield.hasText,
            secondPlaceTextField.hasText
              
        else {
           // self.loginButton.isEnabled = false
           // self.loginButton.backgroundColor = UIColor.rgb(red: 190, green: 140, blue: 196)
            return
        }
        
        guard let first = firstPlaceTextfield.text else {return}
        guard let second = secondPlaceTextField.text else {return}
        // получаем текст из алерта  отпраляем его в функцию и получаем анатацию и точки на карте
        setupPlacemark(adressPlace: first)
        setupPlacemark(adressPlace: second)
      // loginButton.isEnabled = true
      // loginButton.backgroundColor = UIColor.rgb(red: 170, green: 92, blue: 178)
    }
    
   
    
    
    
    @objc fileprivate func touchAddAdress(){
        alertAddAdress(title: "Add one more place", placeholder: "Add adres") {  [self] (text) in
            // print(text)
        // получаем текст из алерта  отпраляем его в функцию и получаем анатацию и точки на карте
        setupPlacemark(adressPlace: text)
        }
        
    
    }
    @objc fileprivate func touchRouteButton(){
        
        guard  annotationsArray.count > 1 else {return}
        
        for index in 0...annotationsArray.count - 2{
            createDirectioReqest(startCoordinate: annotationsArray[index].coordinate, destinationCoordinate: annotationsArray[index + 1].coordinate)
        }
        mapView.showAnnotations(annotationsArray, animated: true)
        
        
    }
    @objc fileprivate func touchResetButton(){
        firstPlaceTextfield.text = ""
        secondPlaceTextField.text = ""
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
        
        // здесь можно убрать активность кнопки
     
        
 
    }
    
    //MARK: - put point for map.
    private func  setupPlacemark(adressPlace: String){
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
            
            annotationsArray.append(anotation)
            
         //  if annotationsArray.count > 2 {
         //      // появиться кнопки если в массиве точек 3 точки адреса
         //  }
            mapView.showAnnotations(annotationsArray, animated: true)
           
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
        // устанавливаем маршрут для пешехода
        request.transportType = .walking
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
        render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196)
        return render
    }
    
}

