//
//  CollectionRoute.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 05/01/2022.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension UIViewController:  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellСollectionRoute
        cell.backgroundColor = UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.5)
        cell.layer.cornerRadius = 20
        return cell
    }
    
    // MARK: - class AppCellСlReminder
    
    class CellСollectionRoute: UICollectionViewCell {
    
        override init(frame: CGRect) {
            super .init(frame: frame)
            setupViews()
        }
                      
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //  let  imageView = CustomUIimageView(frame: .zero)
        lazy var imageView: UIImageView = {
                       
            let iv = UIImageView()
            iv.image = UIImage(named: "avaUser2")
            iv.backgroundColor = .darkGray
            iv.contentMode = .scaleAspectFill
            iv.layer.cornerRadius = 20.0/2.0
            iv.layer.masksToBounds = true
            
            return iv
        }()
  
        let nameUser: UILabel = {
            let Label = UILabel()
            Label.text = "Name Shurname"
            Label.textAlignment = .left
            Label.textColor = .white
            Label.font = UIFont.systemFont(ofSize: 13)
            Label.numberOfLines = 1
            return Label
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
        lazy var stackNameCityContry = UIStackView(arrangedSubviews: [nameCity,nameCountry])
            
            
        func setupViews(){
    
        //  imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 80)
        addSubview(imageView)
            imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 20, height: 20))
       // imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      
        addSubview(nameUser)
            nameUser.anchor(top: topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: nil, pading: .init( top: 7, left: 5, bottom: 0, right: 5), size: .init(width: frame.width-30, height: 0))
       // nameLebel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
        addSubview(nameCurentPlace)
            nameCurentPlace.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init( top: 33, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
            nameCurentPlace.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            //nameCurentPlace.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            stackNameCityContry.axis = .horizontal
            stackNameCityContry.spacing = 0
            stackNameCityContry.distribution = .fillEqually  // для корректного отображения
            
         addSubview(stackNameCityContry)
            stackNameCityContry.anchor(top: nameCurentPlace.bottomAnchor, leading: nameCurentPlace.leadingAnchor, bottom: nil, trailing: nameCurentPlace.trailingAnchor, pading: .init( top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
            stackNameCityContry.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
          
        }
    }
}
