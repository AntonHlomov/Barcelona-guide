//
//  ChatUserCell.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 18/12/2022.
//

import UIKit

class ChatUserCell: UITableViewCell {
    // MARK: - Prop
    var chatUser: ChatUser?{
        didSet{
            //вставляем с помощью extension фото аватарки
            profileImageView.loadImage(with: chatUser?.displayProfileImageUser ?? "")
            guard let chatUserName = chatUser?.displayName else {return}
            guard let chatUserFullname = chatUser?.displayFullName else {return}
            guard let lastMesssage = chatUser?.displayFullName else {return}
            textLabel?.text = chatUserName.capitalized + (" ") + chatUserFullname.capitalized
            detailTextLabel?.text = lastMesssage
        }
    }
    let  profileImageView = CustomUIimageView(frame: .zero)
    lazy var  circleView: UIImageView = {
        let circl = UIImageView()
        circl.backgroundColor = UIColor.appColor(.bluePewter)
        circl.layer.cornerRadius = 70
        circl.layer.borderWidth = 2.5
        circl.layer.borderColor = UIColor.appColor(.pinkLightSalmon)?.cgColor
        return circl
     }()
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.circleView.layer.borderColor = UIColor.appColor(.pinkLightSalmon)?.cgColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(circleView)
        circleView.anchor(top: nil , leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil,pading: .init(top: 0, left: 10, bottom: 0, right: 0),size: .init(width: 70, height: 70) )
        circleView.layer.cornerRadius = 70/2
        circleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(profileImageView)
        profileImageView.anchor(top: circleView.topAnchor, leading: circleView.leadingAnchor, bottom: nil, trailing: nil,pading: .init(top: 5, left: 5, bottom: 0, right: 0),size: .init(width: 60, height: 60))
        profileImageView.layer.cornerRadius = 60/2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textLabel?.text = "Name"
        detailTextLabel?.text = "Last messsage..."
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 110, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 110, y: textLabel!.frame.origin.y + 20, width: frame.width - 200, height: (detailTextLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        textLabel?.textColor = UIColor.appColor(.grayPlatinum)!
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.textColor = UIColor.appColor(.grayPlatinum)!
     }
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
