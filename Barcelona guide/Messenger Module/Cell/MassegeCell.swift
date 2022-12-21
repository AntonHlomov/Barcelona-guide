//
//  MassegeCell.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 14/12/2022.
//

import UIKit

class MassegeCell: UITableViewCell {

    let fonView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.appColor(.bluePewter)
        line.layer.borderColor = UIColor.appColor(.grayPlatinum)?.cgColor
        line.layer.borderWidth = 3
        line.layer.cornerRadius = 14
         return line
     }()
     var labelMasseg: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.text = ""
         label.font =  UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.appColor(.grayPlatinum)!
        label.numberOfLines = 0
         return label
     }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configur()
    }
    func configur() {
        backgroundColor = UIColor.appColor(.bluePewter)
        
        addSubview(fonView)
        fonView.anchor(top: topAnchor , leading: safeAreaLayoutGuide.leadingAnchor, bottom: bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor ,pading: .init(top: 20, left: 10, bottom: 20, right: 140), size: .init(width: 0, height: 0))
        fonView.widthAnchor.constraint(greaterThanOrEqualTo: fonView.widthAnchor , constant: 50).isActive = true
        fonView.heightAnchor.constraint(greaterThanOrEqualTo: fonView.heightAnchor , constant: 40).isActive = true

        addSubview(labelMasseg)
        labelMasseg.anchor(top: fonView.topAnchor , leading: fonView.leadingAnchor, bottom: fonView.bottomAnchor, trailing: fonView.trailingAnchor ,pading: .init(top: 10, left: 10, bottom: 10, right: 18))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
