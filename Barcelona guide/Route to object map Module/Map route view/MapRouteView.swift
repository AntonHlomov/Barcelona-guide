//
//  MapRouteView.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2023.
//

import UIKit
import MapKit

class MapRouteView: UIViewController {
    var presenter: MapAndFooterPresenterProtocol!
    
    var mapView = MKMapView()
    
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
        //self.view.frame.origin.y = self.view.frame.height/7
        view.backgroundColor = .clear
        configurationView()
        setupTapGestureupButoonFon()
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
        upButoonFon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleHeader)))
    }
    @objc fileprivate func toggleHeader(){
        presenter.toggleHeader()
    }
}
extension MapRouteView: MapRouteProtocol{
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
