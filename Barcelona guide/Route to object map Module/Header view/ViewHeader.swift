//
//  ViewHeader.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 09/01/2023.
//

import UIKit

class ViewHeader: UIViewController {
    var presenter: MapAndFooterPresenterProtocol!
    var tableView: UITableView!
    
    var avatarButton = CustomUIimageView(frame: .zero )
    private var nameAvatar: UILabel = {
        let text = UILabel()
        text.text = "Name Shurname"
        text.textColor = UIColor.appColor(.grayPlatinum)
        text.font = UIFont .systemFont(ofSize: 16)
       return text
    }()
   // private var massegImageButoon = UIButton.setupButtonImage(color: .clear, activation: true, invisibility: false, laeyerRadius: 0, alpha: 0.8, resourseNa: "Messenger")
    lazy var stack = UIStackView(arrangedSubviews: [avatarButton,nameAvatar])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.blackVampire)
        configureTableView()
        configurationView()

    }
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableCell.self, forCellReuseIdentifier: MenuTableCell.reuseId)
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.separatorStyle = .none
        tableView.rowHeight = 65
        tableView.backgroundColor = .clear //UIColor.appColor(.blackVampire)
    }
    // MARK: - Configuration view
    func configurationView(){
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, leading:  view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 60, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 45))
        avatarButton.anchor(top:view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, pading: .init(top: 60, left:20, bottom: view.frame.height - 105, right: 0), size: .init(width: 45, height: 45))
        avatarButton.layer.cornerRadius = 45/2
        avatarButton.layer.borderWidth = 3
        avatarButton.layer.borderColor = UIColor.appColor(.bluePewter)!.cgColor
      //  massegImageButoon.anchor(top:nil, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 25, height: 25))
        
        stack.addSubview(tableView)
        tableView.anchor(top: avatarButton.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: -8, left: view.frame.width - 60, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        
    }

}
extension ViewHeader: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  MenuModel.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableCell.reuseId) as! MenuTableCell
       // presenter.menuConecter(index: indexPath)
        guard let menuModel = MenuModel(rawValue: indexPath.row) else {return cell}
        let dataButon = StatePressButonMenu(buton: menuModel, pressButonIndex: 0)
        cell.iconImageView.image = dataButon.imageButon
        cell.myLabel.text = dataButon.descriptionButon
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let cell = self.tableView.cellForRow(at: indexPath) as! MenuTableCell
        guard let menuModel = MenuModel(rawValue: indexPath.row) else {return}
        let pressButonIndex = cell.numberPressButon + 1
        let dataButon = StatePressButonMenu(buton: menuModel, pressButonIndex: pressButonIndex)
        tableView.deselectRow(at: indexPath, animated: true)
        cell.iconImageView.image = dataButon.imageButon
        cell.myLabel.text = dataButon.descriptionButon
        cell.numberPressButon = dataButon.pressButonIndex
        presenter.menuConecter(index: indexPath,indexMode: dataButon.pressButonIndex)
    }
    
}
extension ViewHeader: ViewHeaderProtocol{
  
    func failure(error: Error) {
    }
    
}
