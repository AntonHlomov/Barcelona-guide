//
//  ViewHeader.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 09/01/2023.
//

import UIKit

class ViewHeader: UIViewController {
    var presenter: MapAndFooterPresenterProtocol!
    
    var avatarButton = CustomUIimageView(frame: .zero )
    private var nameAvatar: UILabel = {
        let text = UILabel()
        text.text = "Name Shurname"
        text.textColor = UIColor.appColor(.grayPlatinum)
        text.font = UIFont .systemFont(ofSize: 16)
       return text
    }()
    private var massegImageButoon = UIButton.setupButtonImage(color: .clear, activation: true, invisibility: false, laeyerRadius: 0, alpha: 0.8, resourseNa: "Messenger")
    lazy var stack = UIStackView(arrangedSubviews: [avatarButton,nameAvatar,massegImageButoon])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.blackVampire)
        configurationView()

    }
    // MARK: - Configuration view
    func configurationView(){
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, leading:  view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 60, left: 20, bottom: 0, right: 40), size: .init(width: 0, height: 45))
        avatarButton.anchor(top:nil, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 45, height: 45))
        avatarButton.layer.cornerRadius = 45/2
        avatarButton.layer.borderWidth = 3
        avatarButton.layer.borderColor = UIColor.appColor(.bluePewter)!.cgColor
        massegImageButoon.anchor(top:nil, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 25, height: 25))
        
    }

}
extension ViewHeader: ViewHeaderProtocol{
  
    func failure(error: Error) {
    }
    
}
