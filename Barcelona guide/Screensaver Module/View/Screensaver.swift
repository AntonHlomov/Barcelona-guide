//
//  Screensaver.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import UIKit

class Screensaver: UIViewController {
    var presenter: ScreensaverPresenterProtocol!
  
    let nameAp = UILabel.headerBigText(title: "Philanthropist")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameAp.alpha = 0
        view.backgroundColor = UIColor.appColor(.blackVampire)
        configureViewComponents()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        schowFxname()
    }
    fileprivate func configureViewComponents(){
        view.addSubview(nameAp)
        nameAp.centerInSuperview() //выстовляет по середине экрана
    }
    
    func schowFxname(){
        UIView.animate(withDuration: 5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn,
                       animations: {
            self.nameAp.alpha = 1
        }) { (finished) in }
    }


}
extension Screensaver: ScreensaverProtocol {
    func failure(error: Error){
        
    }
    func alert(title: String, message: String){
        
    }
}
