//
//  PresentRoute.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 06/01/2022.
//

import UIKit

class PresentRoute: UIViewController, UINavigationControllerDelegate {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Barcelona-Sagrada-Familia").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    var blockView: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.7)
        iv.layer.cornerRadius = 25
        return iv
    }()
    var line: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255).withAlphaComponent(0.5)
        iv.layer.cornerRadius = 2
        return iv
    }()
    lazy var imageRoute: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-route-30").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    let nameCurentPlace: UILabel = {
        let Label = UILabel()
        Label.text = "Sagrada de familia"
        Label.textAlignment = .left
        Label.textColor = .white
        Label.font = UIFont.boldSystemFont(ofSize: 18)
        Label.numberOfLines = 1
        return Label
    }()
    let nameCity: UILabel = {
        let Label = UILabel()
        Label.text = "Barcelona"
        Label.textAlignment = .left
        Label.textColor = .white
        Label.font = UIFont.systemFont(ofSize: 14)
        Label.numberOfLines = 1
        Label.adjustsFontSizeToFitWidth = true
        return Label
    }()
    let nameCountry: UILabel = {
        let Label = UILabel()
        Label.text = "Spain"
        Label.textAlignment = .left
        Label.textColor = .white
        Label.font = UIFont.systemFont(ofSize: 14)
        Label.numberOfLines = 1
        Label.adjustsFontSizeToFitWidth = true
        return Label
    }()
    lazy var star: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-звезда-144").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    let starLabel = UILabel.setupLabel(title: "4.5", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    lazy var stackStar = UIStackView(arrangedSubviews: [star,starLabel])
   
    
    lazy var walk: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-булавка-для-карты-24").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    let walkLabel = UILabel.setupLabel(title: "10", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    let kmWalkLabel = UILabel.setupLabel(title: "km", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    lazy var stackWKLabel = UIStackView(arrangedSubviews: [walkLabel,kmWalkLabel])
    lazy var stackWalk = UIStackView(arrangedSubviews: [walk,stackWKLabel])
    
    lazy var time: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-время-48").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    let timeLabel = UILabel.setupLabel(title: "2.5", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    let horsTimeLabel = UILabel.setupLabel(title: "h", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    lazy var stackTHLabel = UIStackView(arrangedSubviews: [timeLabel,horsTimeLabel])
    lazy var stackTime = UIStackView(arrangedSubviews: [time,stackTHLabel])
    lazy var stackInformationRoute = UIStackView(arrangedSubviews: [stackStar,stackWalk,stackTime])
    lazy var stackNameCityContry = UIStackView(arrangedSubviews: [nameCity,nameCountry])
    fileprivate let backButton = UIButton.setupButtonImage(color: UIColor.rgb(red: 255, green: 255, blue: 255),activation: true,invisibility: false, laeyerRadius: 40/2, alpha: 0.3,resourseNa: "icons8-назад-96 (1)")
    fileprivate let showRouteButton = UIButton.setupButtonImage(color: UIColor.rgb(red: 255, green: 255, blue: 255),activation: true,invisibility: false, laeyerRadius: 40/2, alpha: 0.3,resourseNa: "icons8-map00")
    lazy var stackNavigatorButton = UIStackView(arrangedSubviews: [backButton,showRouteButton])
    
    let headingLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Sagrada de familia"
        Label.textAlignment = .left
        Label.textColor = .white
        Label.font = UIFont.systemFont(ofSize: 16)
        Label.numberOfLines = 1
        return Label
    }()
    let aboutText: UITextView = {
        let Label = UITextView()
        Label.textAlignment = .left
        Label.text = "La Sagrada Familia es un reflejo de la plenitud artística de Gaudí: trabajó en ella durante la mayor parte de su carrera profesional, pero especialmente en los últimos años de su carrera, donde llegó a la culminación de su estilo naturalista, haciendo una síntesis de todas las soluciones y estilos probados hasta aquel entonces."
        Label.font = UIFont.systemFont(ofSize: 14)
        Label.textColor = .white
        Label.textContainer.maximumNumberOfLines = 5
        Label.isEditable = false
        Label.backgroundColor = .clear
        return Label
    }()
    fileprivate let bookButton = UIButton.setupButton(title: "Contact the guide", color: UIColor.rgb(red: 255, green: 255, blue: 255), activation: true, invisibility: false, laeyerRadius: 12, alpha: 1, textcolor: UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.9))


    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        hadleres()
    }
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        configureViewComponents()
    }
    func hadleres(){
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        showRouteButton.addTarget(self, action: #selector(backAndShowRoute), for: .touchUpInside)
        bookButton.addTarget(self, action: #selector(book), for: .touchUpInside)
    }
    
    fileprivate func configureViewComponents(){
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        view.addSubview(stackNavigatorButton)
        stackNavigatorButton.axis = .horizontal
        stackNavigatorButton.spacing = view.frame.width - 120
        stackNavigatorButton.distribution = .fillEqually  // для корректного отображения
        stackNavigatorButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 20, left: 30, bottom: 0, right: 30), size: .init(width: view.frame.width - 40, height: 40))
        stackNavigatorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
        
        view.addSubview(blockView)
        blockView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 30, bottom: 25, right: 30), size: .init(width: 0, height: view.frame.height/2.7))
        blockView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
       
        view.addSubview(line)
        line.anchor(top: blockView.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: view.frame.height/11.5, left: 30, bottom: 25, right: 30), size: .init(width: blockView.frame.width - 60, height: 2))
        line.centerXAnchor.constraint(equalTo: blockView.centerXAnchor).isActive = true
        
        stackStar.axis = .horizontal
        stackStar.spacing = 0
        stackStar.distribution = .fillEqually
      
    
        stackWKLabel.axis = .horizontal
        stackWalk.spacing = 0
        stackWKLabel.distribution = .fillEqually
        
        stackWalk.axis = .horizontal
        stackWalk.spacing = 0
        stackWalk.distribution = .fillEqually
        
        stackTHLabel.axis = .horizontal
        stackWalk.spacing = 0
        stackTHLabel.distribution = .fillEqually
        
        stackTime.axis = .horizontal
        stackTime.spacing = 0
        stackTime.distribution = .fillEqually
        
        stackInformationRoute.axis = .horizontal
        stackInformationRoute.spacing = 10
        stackInformationRoute.distribution = .fillEqually
        
        view.addSubview(stackInformationRoute)
        stackInformationRoute.anchor(top: line.topAnchor, leading: line.leadingAnchor, bottom: nil, trailing: line.trailingAnchor, pading: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 23))
       
        
        
        view.addSubview(imageRoute)
        imageRoute.anchor(top: nil, leading: line.leadingAnchor, bottom: line.topAnchor, trailing: nil, pading: .init(top: 0, left: 0, bottom: 15, right: 0), size: .init(width: 0, height: 0))
        
        view.addSubview(nameCurentPlace)
        nameCurentPlace.anchor(top: imageRoute.topAnchor, leading: imageRoute.trailingAnchor, bottom: nil, trailing: nil, pading: .init(top: -2, left: 15, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        view.addSubview(stackNameCityContry)
        stackNameCityContry.anchor(top: nameCurentPlace.bottomAnchor, leading: nameCurentPlace.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        
        view.addSubview(headingLabel)
        headingLabel.anchor(top: stackInformationRoute.bottomAnchor, leading: stackInformationRoute.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        view.addSubview(aboutText)
        aboutText.anchor(top: headingLabel.bottomAnchor, leading: stackInformationRoute.leadingAnchor, bottom: blockView.bottomAnchor, trailing: nil, pading: .init(top: 8, left: -3, bottom: 55, right: 0), size: .init(width: blockView.frame.width - 57, height: 0))
        
        view.addSubview(bookButton)
        bookButton.anchor(top: nil, leading: nil, bottom: blockView.bottomAnchor, trailing: nil, pading: .init(top: 0, left: 30, bottom: 13, right: 30), size: .init(width: blockView.frame.width - 60, height: 30))
        bookButton.centerXAnchor.constraint(equalTo: blockView.centerXAnchor).isActive = true
        
    }
    
    @objc fileprivate func  back(){
    dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func  backAndShowRoute(){
    dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func  book(){
    }
}
