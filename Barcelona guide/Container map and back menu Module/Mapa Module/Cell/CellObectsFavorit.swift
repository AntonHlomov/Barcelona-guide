//
//  CellObectsFavorit.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 14/12/2022.
//

import UIKit

class CellObectsFavorit: UICollectionViewCell {
    var object: Object? {
        didSet {
            imageView.loadImage(with: object?.profileImageUserСreator ?? "")
            imageObjectView.loadImage(with: object?.objectImage ?? "")
            guard let name = object?.nameUserСreator else {return}
            guard let fullname = object?.fullNameUserСreator else {return}
            guard let nameObject = object?.nameObject else {return}
            guard let text = object?.textObject else {return}
            nameUser.text = name.capitalized + " " + fullname.capitalized
            nameObjectCell.text = nameObject.capitalized
            textObject.text = text.capitalized
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.object = nil
        self.imageObjectView.image = nil
        self.imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView = CustomUIimageView(frame: .zero)
    let imageObjectView = CustomUIimageView(frame: .zero)
    let nameUser: UILabel = {
        let Label = UILabel()
        Label.text = "Name Shurname"
        Label.textAlignment = .left
        Label.textColor = UIColor.appColor(.blackOrPlatinumDarckMode)
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
        Label.numberOfLines = 3
        Label.adjustsFontSizeToFitWidth = false
        
        return Label
    }()
  //  var dateCell: UILabel = {
  //      let Label = UILabel()
  //      Label.text = "21.10 12:15"
  //      Label.textAlignment = .left
  //      Label.textColor = UIColor.appColor(.grayPlatinum)?.withAlphaComponent(0.8)
  //      Label.font = UIFont.systemFont(ofSize: 10)
  //      Label.numberOfLines = 1
  //      return Label
  //  }()
    
    func setupViews(){
        addSubview(imageView)
        imageView.anchor(top: nil, leading: leadingAnchor, bottom: topAnchor, trailing: nil, pading: .init(top: 0, left: 8, bottom: 5, right: 0), size: .init(width: 20,height: 20))
        imageView.layer.cornerRadius = 20/2
        
        addSubview(nameUser)
        nameUser.anchor(top: nil, leading: imageView.trailingAnchor, bottom: imageView.bottomAnchor, trailing: nil, pading: .init( top: 0, left: 5, bottom: 0, right: 0), size: .init(width: frame.width-30, height: 0))
        
        addSubview(imageObjectView)
        imageObjectView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, pading: .init(top: 8, left: 0, bottom: 8, right: 8), size: .init(width: frame.width/3,height: frame.height-16))
        imageObjectView.layer.cornerRadius = 12
        
        addSubview(nameObjectCell)
        nameObjectCell.anchor(top: imageObjectView.topAnchor, leading: leadingAnchor, bottom: nil, trailing: imageObjectView.leadingAnchor, pading: .init( top: 0, left: 8, bottom: 0, right: 12), size: .init(width: 0, height: 0))
        
      //  addSubview(dateCell)
      //  dateCell.anchor(top: bottomAnchor, leading: nameObjectCell.leadingAnchor, bottom: nil, trailing: imageObjectView.leadingAnchor, pading: .init( top: 10, left: 10, bottom: 0, right: 12), size: .init(width: 0, height: 0))
        
        addSubview(textObject)
        textObject.anchor(top: nameObjectCell.bottomAnchor, leading: nameObjectCell.leadingAnchor, bottom: bottomAnchor, trailing: imageObjectView.leadingAnchor, pading: .init( top: -18, left: 0, bottom:0, right: 12), size: .init(width: 0, height: 0))
    }
}
