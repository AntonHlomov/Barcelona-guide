//
//  FotterView.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2023.
//

import UIKit

class FotterView: UIViewController {
    var presenter: MapAndFooterPresenterProtocol!
    
    var fotterBox: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayPlatinum)
        view.addShadow()
        return view
    }()
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
    var fotterDownBox: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayPlatinum)
        view.addShadow()
        return view
    }()
    
    let cancelButton = UIButton.setupButton(title: "Cancel", color:  UIColor.appColor(.grayPlatinum)!, activation: true, invisibility: false, laeyerRadius: 8, alpha: 1, textcolor: UIColor.appColor(.grayMidle)!)
    let tookButton = UIButton.setupButton(title: "I took", color:  UIColor.appColor(.bluePewter)!, activation: true, invisibility: false, laeyerRadius: 8, alpha: 1, textcolor: UIColor.appColor(.grayPlatinum)!)
    lazy var stackButton =  UIStackView(arrangedSubviews: [cancelButton,tookButton])
    
    let imageObjectView = CustomUIimageView(frame: .zero)
    let nameObjectCell: UILabel = {
        let Label = UILabel()
        Label.text = "My stuff for free."
        Label.textAlignment = .left
        Label.textColor = UIColor.appColor(.grayMidle)
        Label.font = UIFont.boldSystemFont(ofSize: 18)
        Label.numberOfLines = 1
        return Label
    }()
    
    let textObject: UILabel = {
        let Label = UILabel()
        Label.text = "I give children's sneakers and a red jacket.Token not set before"
        Label.textAlignment = .left
        Label.textColor = UIColor.appColor(.grayMidle)
        Label.font = UIFont.systemFont(ofSize: 14)
        Label.numberOfLines = 3
        Label.adjustsFontSizeToFitWidth = false
        return Label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.origin.y = self.view.frame.height - 65
        view.backgroundColor = .clear
        configureViewComponents()
        setupTapGesture()
        heandlers()
        
        

        // Do any additional setup after loading the view.
    }
    func configureViewComponents(){
        view.addSubview(fotterBox)
        fotterBox.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        fotterBox.layer.cornerRadius = view.frame.width/10
        
        view.addSubview(upButoon)
        upButoon.anchor(top: fotterBox.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 5))
        upButoon.layer.cornerRadius = 2.5
        upButoon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(upButoonFon)
        upButoonFon.anchor(top: fotterBox.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 125, height: 35))
        upButoonFon.layer.cornerRadius = 12
        upButoonFon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(fotterDownBox)
        fotterDownBox.anchor(top: fotterBox.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 150, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
 
        
        stackButton.axis = .horizontal
        stackButton.spacing = 10
        stackButton.distribution = .fillEqually
        
        view.addSubview(stackButton)
        stackButton.anchor(top: fotterDownBox.topAnchor, leading: fotterDownBox.leadingAnchor, bottom: nil, trailing: fotterDownBox.trailingAnchor, pading: .init(top: 20, left: 10, bottom: 140, right: 10), size: .init(width: 0, height: 45))
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.appColor(.grayMidle)?.cgColor
        
        view.addSubview(imageObjectView)
        imageObjectView.anchor(top: fotterBox.topAnchor, leading: nil, bottom: fotterDownBox.topAnchor, trailing: fotterBox.trailingAnchor, pading: .init(top: 25, left: 0, bottom: 8, right: 30), size: .init(width: view.frame.width/3.2, height: fotterBox.frame.height/2.6))
        imageObjectView.layer.cornerRadius = 12
        
        view.addSubview(nameObjectCell)
        nameObjectCell.anchor(top: fotterBox.topAnchor, leading: fotterBox.leadingAnchor, bottom: nil, trailing: imageObjectView.leadingAnchor, pading: .init( top: 30, left: 35, bottom: 0, right: 12), size: .init(width: 0, height: 0))
        
        view.addSubview(textObject)
        textObject.anchor(top: nameObjectCell.bottomAnchor, leading: nameObjectCell.leadingAnchor, bottom: imageObjectView.bottomAnchor, trailing: imageObjectView.leadingAnchor, pading: .init( top: -18, left: 0, bottom:0, right: 12), size: .init(width: 0, height: 0))
       
    }
    func heandlers(){
        cancelButton.addTarget(self, action: #selector(selectorCancelButton), for: .touchUpInside)
        tookButton.addTarget(self, action: #selector(selectorTookButton), for: .touchUpInside)
    }
   
    
    @objc fileprivate func selectorCancelButton(){
        presenter.selectorCancelButton()
    }
    @objc fileprivate func selectorTookButton(){
        presenter.selectorTookButton()
        
    }
    //MARK: - TapGesture and endEditing
    fileprivate func setupTapGesture(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGestureToggleFotter))
            swipeDown.direction = .down
            self.view.addGestureRecognizer(swipeDown)
        upButoonFon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closedMenu)))
    }
    @objc fileprivate func handleGestureToggleFotter(){
        presenter.toggleFotter()
    }
    @objc fileprivate func closedMenu(){
        presenter.toggleFotter()
    }

}

extension FotterView: FotterProtocol{
    func corectionYfotter(headerMove: Bool,fotterMove: Bool) {
       
        switch headerMove{
        case true :
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                switch fotterMove{
                case true:
                    self.view.frame.origin.y = self.view.frame.height - 340
                    
                case false:
                    self.view.frame.origin.y = self.view.frame.height - 135
                    
                }
               
               
            }) { (finished) in
                switch fotterMove{
                case true:
                    self.view.frame.origin.y = self.view.frame.height - 340
                    
                case false:
                    self.view.frame.origin.y = self.view.frame.height - 135
                    
                }
            }
        case false:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                switch fotterMove{
                case true:
                    self.view.frame.origin.y = self.view.frame.height - 280
                case false:
                    self.view.frame.origin.y = self.view.frame.height - 65
                }
               
                
            }) { (finished) in
                switch fotterMove{
                case true:
                    self.view.frame.origin.y = self.view.frame.height - 280
                case false:
                    self.view.frame.origin.y = self.view.frame.height - 65
                }
            }
        }
        
    }
    
    func openFotter(fotterMove: Bool, headerMove: Bool) {
        switch fotterMove{
        case true :
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                switch headerMove{
                case true:
                    self.view.frame.origin.y = self.view.frame.height - 340
                case false:
                    self.view.frame.origin.y = self.view.frame.height - 280
                }
                self.imageObjectView.alpha = 1
                self.nameObjectCell.alpha = 1
                self.textObject.alpha = 1
          
            }) { (finished) in }
        case false:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                switch headerMove{
                case true:
                    self.view.frame.origin.y = self.view.frame.height - 135
                case false:
                    self.view.frame.origin.y = self.view.frame.height - 65
                }
                self.imageObjectView.alpha = 0
                self.nameObjectCell.alpha = 0
                self.textObject.alpha = 0
            
            }) { (finished) in }
        }
    }
    func failure(error: Error) {
        
    }
  
}
