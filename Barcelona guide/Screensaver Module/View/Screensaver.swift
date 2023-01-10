//
//  Screensaver.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import UIKit

class Screensaver: UIViewController {
    var presenter: ScreensaverPresenterProtocol!
    
    let logoImage = UIImageView(image: #imageLiteral(resourceName: "icons8-маркер-на-карте-100 (1)").withRenderingMode(.alwaysOriginal))
    let nameAp = UILabel.headerBigText(title: "Te lo doy")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        configureViewComponents()
    }
    fileprivate func configureViewComponents(){
        view.addSubview(nameAp)
        nameAp.centerInSuperview() //выстовляет по середине экрана
        view.addSubview(logoImage)
        logoImage.anchor(top: nil, leading: nil, bottom: nameAp.topAnchor, trailing: nil, pading: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 250, height: 250))
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
    }


}
extension Screensaver: ScreensaverProtocol {
    func failure(error: Error){
        
    }
    func alert(title: String, message: String){
        
    }
}
