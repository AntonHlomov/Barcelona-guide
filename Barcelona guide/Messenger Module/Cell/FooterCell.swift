//
//  FooterCell.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 15/12/2022.
//

import UIKit

class FooterCell: UITableViewCell {
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configur()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configur(){
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
