//
//  ReservtionView.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 05/01/2023.
//

import UIKit

class ReservtionView: UIViewController {
    var presenter: ReservationViewPresenterProtocol!
    
    var upFonView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        return view
    }()
    var downFonView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayPlatinum)
        return view
    }()
    var centrMesage: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.orangeChinese)
        return view
    }()
    var centrMesageLight: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayPlatinum)
        return view
    }()
    var centrMesageLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayMidle)?.withAlphaComponent(0.5)
        return view
    }()
    var centrFon: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayPlatinum)
        return view
    }()
    var footer: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayPlatinum)
        view.addShadow()
        return view
    }()
    
    let logoImage = UIImageView(image: #imageLiteral(resourceName: "626rocket_100672").withRenderingMode(.alwaysOriginal))
    let questionMain = UILabel.setupLabel(title: "Want to reservation?", alignment: .center, color: UIColor.appColor(.grayPlatinum)!, alpha: 1, size: 32, numberLines: 1)
    let laterButton = UIButton.setupButton(title: "Maybe later", color:  UIColor.appColor(.grayPlatinum)!, activation: true, invisibility: false, laeyerRadius: 8, alpha: 1, textcolor: UIColor.appColor(.grayMidle)!)
    let reservationButton = UIButton.setupButton(title: "Reservation", color:  UIColor.appColor(.bluePewter)!, activation: true, invisibility: false, laeyerRadius: 8, alpha: 1, textcolor: UIColor.appColor(.grayPlatinum)!)
    lazy var stackButton =  UIStackView(arrangedSubviews: [laterButton,reservationButton])
    
    let headingText = UILabel.setupLabel(title: "Pick up this stuff within the specified time.", alignment: .center, color: UIColor.appColor(.grayMidle)!, alpha: 1, size: 14, numberLines: 1)
    
    let conditionsText = UILabel.setupLabel(title: "During the reservation, this stuff is not visible to other users. Once you've picked up the stuff, confirm it in the app.", alignment: .left, color: UIColor.appColor(.grayMidle)!, alpha: 0.9, size: 13, numberLines: 3)
    
    let lowerAdditionalText = UILabel.setupLabel(title: "With the support of the Ayutomento of Barcelona and the Bank of Santander.", alignment: .center, color: UIColor.appColor(.grayMidle)!, alpha: 0.8, size: 12, numberLines: 2)
    let timeLabel = UILabel.setupLabel(title: "Reserve for", alignment: .center, color: UIColor.appColor(.blackVampire)!, alpha: 0.5, size: 26, numberLines: 1)
    
    var time = UILabel.setupLabel(title: "17", alignment: .center, color: UIColor.appColor(.blackVampire)!, alpha: 0.5, size: 26, numberLines: 1)
    
    let timeText = UILabel.setupLabel(title: "min", alignment: .center, color: UIColor.appColor(.blackVampire)!, alpha: 0.5, size: 26, numberLines: 1)
   
    


    override func viewDidLoad() {
        super.viewDidLoad()
      //  view.backgroundColor = UIColor.appColor(.bluePewter)
        handlers()
        configureViewComponents()

        // Do any additional setup after loading the view.
    }
    func configureViewComponents(){
        
        view.addSubview(upFonView)
        upFonView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/1.8))
        
        view.addSubview(downFonView)
        downFonView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/2.2))
        
       
        view.addSubview(centrMesage)
        centrMesage.anchor(top: downFonView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, pading: .init(top: -view.frame.height/10 , left: 20, bottom: 0, right: 20), size: .init(width: view.frame.width, height:view.frame.height/3.5))
        centrMesage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
        centrMesage.layer.cornerRadius = 12
        
        view.addSubview(questionMain)
        questionMain.anchor(top: nil, leading: centrMesage.leadingAnchor, bottom: centrMesage.topAnchor, trailing: centrMesage.trailingAnchor, pading: .init(top: 0, left: 10, bottom: 13, right: 10), size: .init(width: 0, height: 0))
        
        view.addSubview(logoImage)
        logoImage.anchor(top: nil, leading: nil, bottom: questionMain.topAnchor, trailing: nil, pading: .init(top: 0, left: 0, bottom: 30, right: 0), size: .init(width: 150, height: 150))
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(footer)
        footer.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height:view.frame.height/8))
        
        view.addSubview(centrMesageLight)
        centrMesageLight.anchor(top: centrMesage.topAnchor, leading: centrMesage.leadingAnchor, bottom: centrMesage.bottomAnchor, trailing: centrMesage.trailingAnchor, pading: .init(top: 3, left: 3, bottom: 80, right: 3), size: .init(width: 0, height:0))
        centrMesageLight.layer.cornerRadius = 12
   
        view.addSubview(centrFon)
        centrFon.anchor(top:nil, leading: centrMesageLight.leadingAnchor, bottom: centrMesageLight.bottomAnchor, trailing: centrMesageLight.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height:12))
        
        view.addSubview(centrMesageLine)
        centrMesageLine.anchor(top: centrMesageLight.topAnchor, leading: centrMesageLight.leadingAnchor, bottom: nil, trailing: centrMesageLight.trailingAnchor, pading: .init(top: 50, left: 15, bottom: 0, right: 15), size: .init(width: 0, height:1))
        
        view.addSubview(headingText)
        headingText.anchor(top: centrMesageLight.topAnchor, leading: centrMesageLine.leadingAnchor, bottom: centrMesageLine.topAnchor, trailing: centrMesageLine.trailingAnchor, pading: .init(top: 10, left: 0, bottom: 6, right: 0), size: .init(width: 0, height:0))
        
        
        view.addSubview(conditionsText)
        conditionsText.anchor(top: centrMesageLine.topAnchor, leading: centrMesageLine.leadingAnchor, bottom: centrMesageLight.bottomAnchor, trailing: centrMesageLine.trailingAnchor, pading: .init(top: 10, left: 15, bottom: 10, right: 5), size: .init(width: 0, height:0))
        
       
        view.addSubview(timeLabel)
        timeLabel.anchor(top: centrMesageLight.bottomAnchor, leading: centrMesage.leadingAnchor, bottom: centrMesage.bottomAnchor, trailing: nil, pading: .init(top: 20, left: 60, bottom: 12, right: 0), size: .init(width: 0, height:0))
        
        view.addSubview(time)
        time.anchor(top: centrMesageLight.bottomAnchor, leading: timeLabel.trailingAnchor, bottom: centrMesage.bottomAnchor, trailing: nil, pading: .init(top: 20, left: 4, bottom: 12, right: 0), size: .init(width: 0, height:0))
        
        view.addSubview(timeText)
        timeText.anchor(top: centrMesageLight.bottomAnchor, leading: time.trailingAnchor, bottom: centrMesage.bottomAnchor, trailing: nil, pading: .init(top: 20, left: 4, bottom: 12, right: 0), size: .init(width: 0, height:0))
        
        view.addSubview(lowerAdditionalText)
        lowerAdditionalText.anchor(top: centrMesage.bottomAnchor, leading: centrMesage.trailingAnchor, bottom: nil, trailing: centrMesage.trailingAnchor, pading: .init(top: -10, left: 25, bottom: 0, right: 25), size: .init(width: 0, height:80))
        lowerAdditionalText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        
        stackButton.axis = .horizontal
        stackButton.spacing = 10
        stackButton.distribution = .fillEqually
        
        view.addSubview(stackButton)
        stackButton.anchor(top: footer.topAnchor, leading: centrMesage.leadingAnchor, bottom: nil, trailing: centrMesage.trailingAnchor, pading: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        laterButton.layer.borderWidth = 2
        laterButton.layer.borderColor = UIColor.appColor(.grayMidle)?.cgColor
    }
    func handlers(){
        laterButton.addTarget(self, action: #selector(selectorLaterButton), for: .touchUpInside)
        reservationButton.addTarget(self, action: #selector(selectorReservationButton), for: .touchUpInside)
    }
    @objc fileprivate func selectorLaterButton(){
        presenter.targetMaybeLater()
    }
    @objc fileprivate func selectorReservationButton(){
    print("selectorReservationButton")
        presenter.targetReservation()
    }
    


}
extension ReservtionView: ReservationViewProtocol{
    func setTime(timeRoute: String) {
        self.time.text = timeRoute
    }
    
    func failure(error: Error) {
        print("Messenger failure")
    }
    
    func sucses() {
        print("sucses")
    }
   
}
