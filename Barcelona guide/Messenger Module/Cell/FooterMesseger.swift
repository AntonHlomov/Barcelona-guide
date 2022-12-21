//
//  FooterMesseger.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 15/12/2022.
//

import UIKit

class FooterMesseger: UITableViewHeaderFooterView {

   
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let footer = UIView()
        footer.backgroundColor = UIColor.appColor(.grayMidle)
        let footerUp = UIView(frame: CGRect(x: 0, y: 0, width: frame.width+2, height: 65))
        //footerUp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        footerUp.backgroundColor = UIColor.appColor(.grayPlatinum)
        footerUp.layer.borderWidth = 1
        footerUp.layer.borderColor = UIColor.appColor(.grayMidle)?.withAlphaComponent(0.6).cgColor
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 350, height: 30))
        titleLabel.textColor = UIColor.appColor(.grayPlatinum)
        titleLabel.text  = "Futer"
        footer.addSubview(footerUp)
        footer.addSubview(titleLabel)
    }
   

}
