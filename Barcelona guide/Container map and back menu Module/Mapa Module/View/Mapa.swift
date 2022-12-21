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
    var presenter: ContainerMapAndMenuPresenterProtocol!

    fileprivate let map: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    let locationManager = CLLocationManager()
    var annotationsArray = [MKPointAnnotation]()
    let annotationUser = MKPointAnnotation()
    

    let userImageButton = CustomUIimageView(frame: .zero )
    
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
    
    fileprivate let menu = UIButton.setupButtonImage( color: UIColor.appColor(.bluePewter)!,activation: true,invisibility: false, laeyerRadius: 12, alpha:0.6,resourseNa: "menu")
    
    fileprivate let carOrWhalkButton = UIButton.setupButtonImage( color: UIColor.rgb(red: 190, green: 140, blue: 196),activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "car")
    
    fileprivate let styleMap = UIButton.setupButtonImage(color: UIColor.rgb(red: 31, green: 152, blue: 233),activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "map")
    
    fileprivate let userLocationButton = UIButton.setupButtonImage(color: UIColor.rgb(red: 31, green: 152, blue: 233),activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "arrow")
    
    fileprivate let addNewObjectButton = UIButton.setupButtonImage( color: UIColor.appColor(.pinkLightSalmon)!,activation: true,invisibility: false, laeyerRadius: 12, alpha: 0.6,resourseNa: "add")
    
    lazy var upRStackButton = UIStackView(arrangedSubviews: [styleMap,carOrWhalkButton,userLocationButton])
    lazy var downRStackButton = UIStackView(arrangedSubviews: [menu,addNewObjectButton])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
      //  self.navigationItem.leftBarButtonItem?.tintColor = UIColor.appColor(.grayPlatinum)
        
        map.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        OnOflocationManager()
        configureViewComponents()
        
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        appsCollectionView.register(CellObectsFavorit.self, forCellWithReuseIdentifier: cellId)
        
        setupTapGesture()
        hadleres()
        
        locationManager.startUpdatingLocation()
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 41.380422846823755, longitude: 2.154067881398437)
              annotation1.title = "Кофе за 1 $" // Optional
              annotation1.subtitle = "Вкусный кофе " // Optional
              self.map.addAnnotation(annotation1)
     
       
 
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
        
        
        view.addSubview(appsCollectionView)
        appsCollectionView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/6.2))
        
        upRStackButton.axis = .vertical
        upRStackButton.spacing = 15
        upRStackButton.distribution = .fillEqually
        view.addSubview(upRStackButton)
        upRStackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 30, left: 0 , bottom: 0, right:10), size: .init(width: 40, height: 122.5))
      
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
        styleMap.tag = 0
        styleMap.addTarget(self, action: #selector(selectorStyleMap(sender:)), for: .touchUpInside)
        userLocationButton.tag = 1
        userLocationButton.addTarget(self, action: #selector(selectorUserLocationButton(sender:)), for: .touchUpInside)
        addNewObjectButton.tag = 0
        addNewObjectButton.addTarget(self, action: #selector(selectorAddNewObjectButton(sender:)), for: .touchUpInside)
        carOrWhalkButton.tag = 1
        carOrWhalkButton.addTarget(self, action: #selector(changeCarOrWhalk(sender:)), for: .touchUpInside)
    }
    @objc fileprivate func selectorMenu(){
        print("selectorMenu")
       presenter.goToCollectionLocation()
    
    }
    @objc fileprivate func selectorUserButton(){
        print("selectorUserButton")
         presenter.toggleMenu()
    }
    
    @objc fileprivate func selectorStyleMap(sender: UIButton){
        switch map.mapType {
        case .standard:
            map.mapType = .satellite
        case .satellite:
            map.mapType = .hybrid
        case .hybrid:
            map.mapType = .satelliteFlyover
        case .satelliteFlyover:
            map.mapType = .hybridFlyover
        case .hybridFlyover:
            map.mapType = .mutedStandard
        case .mutedStandard:
            map.mapType = .standard
        @unknown default:
            map.mapType = .standard
        }
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
        presenter?.showAddNewOject()
    }
    
    @objc fileprivate func changeCarOrWhalk(sender: UIButton){
       
       switch sender.tag {
       case 0:
           UIView.animate(withDuration: 0.25, animations: {
               self.carOrWhalkButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
           })
           carOrWhalkButton.tag = 1
           carOrWhalkButton.setImage(#imageLiteral(resourceName: "icons8-car180-60"), for:.normal)
           carOrWhalkButton.backgroundColor = UIColor.rgb(red: 31, green: 152, blue: 233).withAlphaComponent(0.6)
          
       case 1:
           UIView.animate(withDuration: 0.25, animations: {
               self.carOrWhalkButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
           })
           carOrWhalkButton.tag = 0
           carOrWhalkButton.setImage(#imageLiteral(resourceName: "icons8-whalk-30"), for:.normal)
           carOrWhalkButton.backgroundColor = UIColor.rgb(red: 190, green: 140, blue: 196).withAlphaComponent(0.6)
          
       default:
           return
       }
        
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
      view.endEditing(true)
  }

}
//MARK: - extension

extension Mapa: MKMapViewDelegate{
    
    // отрисовка на карте маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        switch carOrWhalkButton.tag {
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

extension Mapa: ContainerMapAndMenuProtocol {
    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            // показываем menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.view.frame.origin.x = self.view.frame.width - 230
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
    
    func setUser(user: User) {
        userImageButton.loadImage(with: user.profileImageUser ?? "")
        userImageButton.layer.borderWidth = 3
        userImageButton.layer.borderColor = UIColor.appColor(.bluePewter)!.cgColor
    }
    func failure(error: Error){
        
    }
    func alert(title: String, message: String){
        
    }
}
