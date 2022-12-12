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

class Mapa: UIViewController,CLLocationManagerDelegate,UINavigationControllerDelegate{
    var presenter: MapaPresenterProtocol!
    fileprivate let map: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    let locationManager = CLLocationManager()
    var annotationsArray = [MKPointAnnotation]()
    let annotationUser = MKPointAnnotation()
    

    let userImageButton = CustomUIimageView(frame: .zero )
    
    fileprivate var colectionView: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.7)
       // iv.layer.cornerRadius = 25
        return iv
    }()
    fileprivate let menu = UIButton.setupButtonImage( color: .clear,activation: true,invisibility: false, laeyerRadius: 12, alpha: 0,resourseNa: "menu")
    
    fileprivate let carOrWhalkButton = UIButton.setupButtonImage( color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "car")
    
    fileprivate let styleMap = UIButton.setupButtonImage(color: UIColor.rgb(red: 31, green: 152, blue: 233),activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "map")
    
    fileprivate let userLocationButton = UIButton.setupButtonImage(color: UIColor.rgb(red: 31, green: 152, blue: 233),activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "arrow")
    
    fileprivate let addNewObjectButton = UIButton.setupButtonImage( color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "add")
    
    lazy var leaftStackButton = UIStackView(arrangedSubviews: [carOrWhalkButton,styleMap])
    lazy var rightStackButton = UIStackView(arrangedSubviews: [userLocationButton,addNewObjectButton])
    lazy var generalStackButton = UIStackView(arrangedSubviews: [leaftStackButton,rightStackButton])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
      //  self.navigationItem.leftBarButtonItem?.tintColor = UIColor.appColor(.grayPlatinum)
        
        map.delegate = self
        locationManager.requestWhenInUseAuthorization()
        OnOflocationManager()
        configureViewComponents()
        setupTapGesture()
        hadleres()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    fileprivate func configureViewComponents(){
        
        view.addSubview(map)
        map.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        view.addSubview(userImageButton)
        userImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 30, left: 20, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        userImageButton.layer.cornerRadius = 70/2
        
        view.addSubview(menu)
        menu.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 50, height: 50))
        menu.layer.cornerRadius = 12
        
        view.addSubview(colectionView)
        colectionView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/6.2))
        
        leaftStackButton.axis = .vertical
        leaftStackButton.spacing = 15
        leaftStackButton.distribution = .fillEqually
      
        rightStackButton.axis = .vertical
        rightStackButton.spacing = 15
        rightStackButton.distribution = .fillEqually
        
        generalStackButton.axis = .horizontal
        generalStackButton.spacing = view.frame.width - 120
        generalStackButton.distribution = .fillEqually  // дляя
        view.addSubview(generalStackButton)
        generalStackButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: colectionView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 10 , bottom: 25, right:10), size: .init(width: 50, height: 115))
    }
    func hadleres(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(Mapa.selectorUserButton))
        userImageButton.addGestureRecognizer(tap)
        userImageButton.isUserInteractionEnabled = true
        menu.addTarget(self, action: #selector(selectorMenu), for: .touchUpInside)
        styleMap.tag = 0
        styleMap.addTarget(self, action: #selector(selectorStyleMap(sender:)), for: .touchUpInside)
        userLocationButton.tag = 0
        userLocationButton.addTarget(self, action: #selector(selectorUserLocationButton(sender:)), for: .touchUpInside)
        addNewObjectButton.tag = 0
        addNewObjectButton.addTarget(self, action: #selector(selectorAddNewObjectButton(sender:)), for: .touchUpInside)
    }
    @objc fileprivate func selectorMenu(){
        presenter.goToCollectionLocation()
    
    }
    @objc fileprivate func selectorUserButton(){
        print("selectorUserButton")
        presenter.openSettingsUser()
    }
    @objc fileprivate func selectorStyleMap(sender: UIButton){
        do{ try Auth.auth().signOut() }
        catch { let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Faild to sign out"]) }
    }
    @objc fileprivate func selectorUserLocationButton(sender: UIButton){
        switch sender.tag  {
        case 0:
            UIView.animate(withDuration: 0.25, animations: {
                self.userLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
            locationManager.startUpdatingLocation()
            userLocationButton.tag = 1
          //  userLocationButtonCircle.backgroundColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.6)
           
        case 1:
            UIView.animate(withDuration: 0.25, animations: {
                self.userLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            })
            locationManager.stopUpdatingLocation()
            userLocationButton.tag = 0
           // userLocationButtonCircle.backgroundColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.6)
        default:
            return
        }
    }
    @objc fileprivate func selectorAddNewObjectButton(sender: UIButton){
        presenter.showAddNewOject()
    }
    
    func OnOflocationManager(){
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
    //MARK: - TapGesture and endEditing
    
  fileprivate func setupTapGesture(){
      map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
  }
  @objc fileprivate func handleTapDismiss(){
      view.endEditing(true)
  }

}
//MARK: - extension

extension Mapa: MKMapViewDelegate{
    
    // отрисовка на карте маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
    //    switch styleCarOrWhalk.tag {
    //    case 0:
    //        render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.7)
    //    case 1:
    //        render.strokeColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.7)
    //
    //    default:
    //        render.strokeColor = UIColor.rgb(red: 190, green: 140, blue: 196)
    //    }
        
        return render
    }
}
extension Mapa: MapaProtocol {
    
    func setUser(user: User) {
        
        //let profileImageView = (CustomUIimageView(frame: .zero ))
        userImageButton.loadImage(with: user.profileImageUser ?? "")
        userImageButton.layer.borderWidth = 3
        userImageButton.layer.borderColor = UIColor.appColor(.bluePewter)!.cgColor
      
    }
    
    func failure(error: Error){
        
    }
    func alert(title: String, message: String){
        
    }
}
