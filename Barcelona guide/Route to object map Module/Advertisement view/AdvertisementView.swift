//
//  AdvertisementView.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2023.
//

import UIKit

class AdvertisementView: UIViewController {
    var presenter: MapAndFooterPresenterProtocol!
    
    var mrcetImage = UIImageView(image: #imageLiteral(resourceName: "santander").withRenderingMode(.alwaysOriginal))
    let letsGoButton = UIButton.setupButton(title: "Let's go", color:  .clear, activation: true, invisibility: false, laeyerRadius: 8, alpha: 0, textcolor: UIColor.appColor(.grayPlatinum)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 126, green: 0, blue: 1)
        configurationView()
        heandlers()
    }
    func configurationView(){
        mrcetImage.contentMode = .scaleAspectFill
        // image =  #imageLiteral(resourceName: "Profile2").withRenderingMode(.alwaysOriginal)
        mrcetImage.clipsToBounds = true
        view.addSubview(mrcetImage)
        mrcetImage.centerInSuperview()
        mrcetImage.layer.cornerRadius = 15
        
        view.addSubview(letsGoButton)
        letsGoButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 20, bottom: view.frame.height/10, right: 20), size: .init(width: 80, height: 40))
        letsGoButton.layer.borderWidth = 2
        letsGoButton.layer.borderColor = UIColor.appColor(.grayPlatinum)?.cgColor
        //letsGoButton.backgroundColor = .clear
        letsGoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        letsGoButton.layer.cornerRadius = 12
    }
    func heandlers(){
        letsGoButton.addTarget(self, action: #selector(closedMenu), for: .touchUpInside)
    }
    
    @objc fileprivate func closedMenu(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
            // self.view.frame.origin.x = self.view.frame.width - 140
            self.view.alpha = 0.0
            self.presenter.openAllMenu()
            
        }) { [] (finished) in
            //self.view.frame.origin.x = self.view.frame.width
            self.view.removeFromSuperview()
        }
    }
}
extension AdvertisementView: AdvertisementProtocol{
   
    func failure(error: Error) {
    }
}
