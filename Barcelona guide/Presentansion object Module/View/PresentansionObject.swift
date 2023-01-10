//
//  PresentansionObject.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 09/12/2022.
//

import UIKit

class PresentansionObject: UIViewController {
    var presenter: PresentansionObjectPresenterProtocol!
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Barcelona-Sagrada-Familia").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
      
        return iv
    }()
    lazy var blockView: UIView = {
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
    lazy var imageRoute = CustomUIimageView(frame: .zero)
  
  //  lazy var imageRoute: UIImageView = {
  //      let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-route-30").withRenderingMode(.alwaysOriginal))
  //      iv.backgroundColor = .clear
  //      iv.contentMode = .scaleAspectFit
  //      iv.layer.cornerRadius = 25
  //      iv.layer.masksToBounds = true
  //      return iv
  //  }()
    var nameCategoryObject: UILabel = {
        let Label = UILabel()
        Label.text = "Sagrada de familia"
        Label.textAlignment = .left
        Label.textColor = .white
        Label.font = UIFont.boldSystemFont(ofSize: 18)
        Label.numberOfLines = 1
        return Label
    }()
    let nameUserCreator: UILabel = {
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
    lazy var starLabel = UILabel.setupLabel(title: "4.5", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    lazy var stackStar = UIStackView(arrangedSubviews: [star,starLabel])
   
    
    lazy var walk: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-булавка-для-карты-24").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var distansLabel = UILabel.setupLabel(title: "10", alignment: .right, color: .white, alpha: 1, size: 13, numberLines: 1)
    let kmWalkLabel = UILabel.setupLabel(title: "km", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    lazy var stackWKLabel = UIStackView(arrangedSubviews: [distansLabel,kmWalkLabel])
    lazy var stackWalk = UIStackView(arrangedSubviews: [walk,stackWKLabel])
    
    lazy var time: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "icons8-время-48").withRenderingMode(.alwaysOriginal))
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var timeLabel = UILabel.setupLabel(title: "2.5", alignment: .right, color: .white, alpha: 1, size: 13, numberLines: 1)
    let horsTimeLabel = UILabel.setupLabel(title: "min", alignment: .left, color: .white, alpha: 1, size: 13, numberLines: 1)
    lazy var stackTHLabel = UIStackView(arrangedSubviews: [timeLabel,horsTimeLabel])
    lazy var stackTime = UIStackView(arrangedSubviews: [time,stackTHLabel])
    lazy var stackInformationRoute = UIStackView(arrangedSubviews: [stackStar,stackWalk,stackTime])
    lazy var stackNameCityContry = UIStackView(arrangedSubviews: [nameUserCreator,nameCountry])

    
    let nameObjectLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Sagrada de familia"
        Label.textAlignment = .left
        Label.textColor = .white
        Label.font = UIFont.systemFont(ofSize: 16)
        Label.numberOfLines = 1
        return Label
    }()
    let textAboutObject: UITextView = {
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
    fileprivate let reservButton = UIButton.setupButton(title: "Make reservation", color: UIColor.rgb(red: 255, green: 255, blue: 255), activation: true, invisibility: false, laeyerRadius: 12, alpha: 1, textcolor: UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.9))
    
    fileprivate let sendMessageButton = UIButton.setupButton(title: "Send message", color: UIColor.rgb(red: 255, green: 255, blue: 255), activation: true, invisibility: false, laeyerRadius: 12, alpha: 1, textcolor: UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.9))


    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image:  #imageLiteral(resourceName: "icons8-flying-star-40"), style: .done, target: self, action: #selector(buttonStar))
        self.navigationController?.navigationBar.tintColor = UIColor.appColor(.grayPlatinum)
       
        configureViewComponents()
        hadleres()
    }
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        configureViewComponents()
    }
    func hadleres(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapRemoveBlockInformation))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        reservButton.addTarget(self, action: #selector(reserv), for: .touchUpInside)
        sendMessageButton.addTarget(self, action: #selector(sendMassegeSelector), for: .touchUpInside)
    }
    
    fileprivate func configureViewComponents(){
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        
        view.addSubview(blockView)
        blockView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 30, bottom: 25, right: 30), size: .init(width: 0, height: view.frame.height/2.7))
        blockView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
       
        blockView.addSubview(line)
        line.anchor(top: blockView.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: view.frame.height/11.5, left: 30, bottom: 25, right: 30), size: .init(width: blockView.frame.width - 60, height: 2))
        line.centerXAnchor.constraint(equalTo: blockView.centerXAnchor).isActive = true
        
        stackStar.axis = .horizontal
        stackStar.spacing = 0
        stackStar.distribution = .fillEqually
      
    
        stackWKLabel.axis = .horizontal
        stackWalk.spacing = 1
       // stackWKLabel.distribution = .fillEqually
        
        stackWalk.axis = .horizontal
        stackWalk.spacing = 0
      //  stackWalk.distribution = .fillEqually
        
        stackTHLabel.axis = .horizontal
        stackWalk.spacing = 1
       // stackTHLabel.distribution = .fillEqually
        
        stackTime.axis = .horizontal
        stackTime.spacing = 1
     //   stackTime.distribution = .fillEqually
        
        stackInformationRoute.axis = .horizontal
        stackInformationRoute.spacing = 10
        stackInformationRoute.distribution = .fillEqually
        
        blockView.addSubview(stackInformationRoute)
        stackInformationRoute.anchor(top: line.topAnchor, leading: line.leadingAnchor, bottom: nil, trailing: line.trailingAnchor, pading: .init(top: 16, left: -20, bottom: 0, right: -20), size: .init(width: 0, height: 23))
       
        
        
        blockView.addSubview(imageRoute)
        imageRoute.anchor(top: nil, leading: line.leadingAnchor, bottom: line.topAnchor, trailing: nil, pading: .init(top: 0, left: 0, bottom: 15, right: 0), size: .init(width: 40, height: 40))
        imageRoute.layer.cornerRadius = 40/2
        
        
        blockView.addSubview(nameCategoryObject)
        nameCategoryObject.anchor(top: imageRoute.topAnchor, leading: imageRoute.trailingAnchor, bottom: nil, trailing: nil, pading: .init(top: -2, left: 15, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        blockView.addSubview(stackNameCityContry)
        stackNameCityContry.anchor(top: nameCategoryObject.bottomAnchor, leading: nameCategoryObject.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        
        blockView.addSubview(nameObjectLabel)
        nameObjectLabel.anchor(top: stackInformationRoute.bottomAnchor, leading: stackInformationRoute.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 16, left: 10, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        blockView.addSubview(textAboutObject)
        textAboutObject.anchor(top: nameObjectLabel.bottomAnchor, leading: stackInformationRoute.leadingAnchor, bottom: blockView.bottomAnchor, trailing: nil, pading: .init(top: 8, left: 10, bottom: 55, right: 0), size: .init(width: blockView.frame.width - 57, height: 0))
        
        blockView.addSubview(reservButton)
        reservButton.anchor(top: nil, leading: nil, bottom: blockView.bottomAnchor, trailing: nil, pading: .init(top: 0, left: 30, bottom: 13, right: 30), size: .init(width: blockView.frame.width - 60, height: 30))
        reservButton.centerXAnchor.constraint(equalTo: blockView.centerXAnchor).isActive = true
        
        blockView.addSubview(sendMessageButton)
        sendMessageButton.anchor(top: nil, leading: nil, bottom: reservButton.topAnchor, trailing: nil, pading: .init(top: 0, left: 30, bottom: 10, right: 30), size: .init(width: blockView.frame.width - 60, height: 30))
        sendMessageButton.centerXAnchor.constraint(equalTo: blockView.centerXAnchor).isActive = true
        
    }
    @objc fileprivate func  back(){
        presenter.backToMap()
    }
    @objc fileprivate func  backAndShowRoute(){
    }
    @objc fileprivate func  reserv(){
        presenter.makeReservation()
    }
    @objc fileprivate func  sendMassegeSelector(){
        presenter.sendMassege()
    }
    @objc fileprivate func buttonStar(){
        
    }
    //MARK: - TapGesture and endEditing
    
    var flag = true
  @objc fileprivate func handleTapRemoveBlockInformation(){
   
      switch flag{
      case false:
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
              self.blockView.transform = .identity
             // self.blockView.transform = CGAffineTransform(translationX: 0, y: -300 - 60)
          }, completion: nil)
          flag = true
      case true:
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
              self.blockView.transform = CGAffineTransform(translationX: 0, y: self.blockView.frame.height + 60)
             // self.view.transform = .identity     // интерфейс опускаеться в низ
          }, completion: nil)
          flag = false
      }
  }
}


extension PresentansionObject: PresentansionObjectProtocol {
    func setObjectData(object: Object, distans: String, time: String) {
        imageRoute.loadImage(with: object.profileImageUserСreator ?? "")
        imageView.loadImage(with: object.objectImage ?? "")
        guard let name = object.nameUserСreator else {return}
        guard let fullname = object.fullNameUserСreator else {return}
        guard let nameObject = object.nameObject else {return}
        guard let text = object.textObject else {return}
        guard let category = object.categoryObject else {return}
        nameUserCreator.text = name.capitalized + " " + fullname.capitalized
        nameObjectLabel.text = nameObject.capitalized
        textAboutObject.text = text.capitalized
        nameCategoryObject.text = category.capitalized
        distansLabel.text = distans
        timeLabel.text = time
        
    }
    func failure(error: Error){
        
    }
    func reload(){
        
    }
    func alert(title: String, message: String){
        
    }
}
