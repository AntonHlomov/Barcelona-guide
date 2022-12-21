//
//  CellObectsFavorit.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 14/12/2022.
//

import UIKit

class CellObectsFavorit: UICollectionViewCell {
    
    var object: Object? {
        //  didSet означает что эти пораметры класса можно транслировать по  приложениею
        didSet {
            imageView.loadImage(with: object?.profileImageUserСreator ?? "")
            guard let name = object?.nameUserСreator else {return}
            guard let fullname = object?.fullNameUserСreator else {return}
            guard let nameObject = object?.nameObject else {return}
            guard let text = object?.textObject else {return}
            nameUser.text = name.capitalized + " " + fullname.capitalized
            nameObjectCell.text = nameObject.capitalized
            textObject.text = text.capitalized
            
        }
    }
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      let  imageView = CustomUIimageView(frame: .zero)
    
  //  lazy var imageView: UIImageView = {
  //
  //      let iv = UIImageView()
  //      iv.image = UIImage(named: "avaUser2")
  //      iv.backgroundColor = .darkGray
  //      iv.contentMode = .scaleAspectFill
  //      iv.layer.cornerRadius = 20.0/2.0
  //      iv.layer.masksToBounds = true
  //
  //      return iv
  //  }()
    
    let nameUser: UILabel = {
        let Label = UILabel()
        Label.text = "Name Shurname"
        Label.textAlignment = .left
        Label.textColor = UIColor.appColor(.grayPlatinum)
        Label.font = UIFont.systemFont(ofSize: 13)
        Label.numberOfLines = 1
        return Label
    }()
    let nameObjectCell: UILabel = {
        let Label = UILabel()
        Label.text = "My stuff for free."
        Label.textAlignment = .left
        Label.textColor = UIColor.appColor(.grayPlatinum)
        Label.font = UIFont.boldSystemFont(ofSize: 18)
        Label.numberOfLines = 1
        return Label
    }()
    let textObject: UILabel = {
        let Label = UILabel()
        Label.text = "I give children's sneakers and a red jacket.Token not set before"
        Label.textAlignment = .left
        Label.textColor = UIColor.appColor(.grayPlatinum)
        Label.font = UIFont.systemFont(ofSize: 14)
        Label.numberOfLines = 1
        Label.adjustsFontSizeToFitWidth = false
    
        return Label
    }()

  
    
    
    func setupViews(){
        
        //  imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 80)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 20,height: 20))
        imageView.layer.cornerRadius = 20/2
        // imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(nameUser)
        nameUser.anchor(top: topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: nil, pading: .init( top: 7, left: 5, bottom: 0, right: 5), size: .init(width: frame.width-30, height: 0))
        // nameLebel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(nameObjectCell)
        nameObjectCell.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: trailingAnchor, pading: .init( top: -12, left: 0, bottom: 0, right: 5), size: .init(width: 0, height: 0))
       
        addSubview(textObject)
        textObject.anchor(top: nameObjectCell.bottomAnchor, leading: nameObjectCell.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, pading: .init( top: -18, left: 0, bottom: 6, right: 5), size: .init(width: 0, height: 0))
       
        
    }
}
