//
//  MenuTableCell.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 19/12/2022.
//

import UIKit

class MenuTableCell: UITableViewCell {
    static let reuseId = "MenuTableCell"
    var numberPressButon = 0
    
    let iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let myLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Кастомный текст"
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(myLabel)
        
        backgroundColor = .clear
        
        // iconImageView constaints
     //   iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     //   iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
     //   iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
     //   iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
     //
     //   // myLabel constaints
     //   myLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     //   myLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12).isActive = true
        
        // iconImageView constaints
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        // myLabel constaints
        myLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
