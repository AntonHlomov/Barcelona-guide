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
        
        hadleres()
        configureViewComponents()
        setupTapGesture()
     
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        configureViewComponents()
    }
    
    
    
    func hadleres(){
    
    addAdressButton.addTarget(self, action: #selector(touchAddAdress), for: .touchUpInside)
    routeButton.addTarget(self, action: #selector(touchRouteButton), for: .touchUpInside)
    resetButton.addTarget(self, action: #selector(touchResetButton), for: .touchUpInside)
 
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
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
      
    }
    @objc fileprivate func handleTapDismiss(){
        view.endEditing(true)
    }
    
    
    
    @objc fileprivate func touchAddAdress(){
        alertAddAdress(title: "Add one more place", placeholder: "Add adres") {  [self] (text) in
            // print(text)
        // получаем текст из алерта  отпраляем его в функцию и получаем анатацию и точки на карте
        setupPlacemark(adressPlace: text)
        }
        
    
    }
    @objc fileprivate func touchRouteButton(){
        print("touchRouteButton")
    }
    @objc fileprivate func touchResetButton(){
        print("touchResetButton")
    }
    
    //MARK: - funcional, put point for map.
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
      

}

