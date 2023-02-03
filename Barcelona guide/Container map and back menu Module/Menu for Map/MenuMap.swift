//
//  MenuMap.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 19/12/2022.
//

import UIKit

class MenuMap: UIViewController {
    var presenter: ContainerMapAndMenuPresenterProtocol!
    var tableView: UITableView!
    var userButton = CustomUIimageView(frame: .zero )
    private var nameAvatar: UILabel = {
        let text = UILabel()
        text.text = "Name Shurname"
        text.textColor = UIColor.appColor(.grayPlatinum)
        text.font = UIFont .systemFont(ofSize: 16)
       return text
    }()
    lazy var stack = UIStackView(arrangedSubviews: [userButton,nameAvatar])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.blackVampire)
        configureTableView()
        configurationView()
        targetButtons()
    }
    func configurationView(){
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, leading:  view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 60, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 45))
        userButton.anchor(top:view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, pading: .init(top: 60, left:20, bottom: view.frame.height - 105, right: 0), size: .init(width: 45, height: 45))
        userButton.layer.cornerRadius = 45/2
        userButton.layer.borderWidth = 3
        userButton.layer.borderColor = UIColor.appColor(.bluePewter)!.cgColor
        
        view.addSubview(tableView)
        tableView.anchor(top: userButton.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: -8, left: view.frame.width - 60, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableCell.self, forCellReuseIdentifier: MenuTableCell.reuseId)
      //  view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.separatorStyle = .none
        tableView.rowHeight = 65
        tableView.backgroundColor = UIColor.appColor(.blackVampire)
    }
    func targetButtons(){
        let tapUserImage = UITapGestureRecognizer(target: self, action: #selector(MenuMap.selectorUserButton))
        userButton.addGestureRecognizer(tapUserImage)
        userButton.isUserInteractionEnabled = true
    }
    @objc fileprivate func selectorUserButton(){
        presenter.toggleMenu()
    }
}

extension MenuMap: UITableViewDelegate, UITableViewDataSource {
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
extension MenuMap: MenuViewProtocol {
    func setDataUserButton(user: User?) {
       // self.user = user
        userButton.loadImage(with: user?.profileImageUser ?? "")
        guard let name = user?.nameUser else {return}
        guard let fullName = user?.fullNameUser else {return}
        nameAvatar.text = name + " " + fullName
    }
    func setDataButtonMenu(indexPath: IndexPath){
        print("setDataButtonMenu")
      //  guard var cell = self.tableView.cellForRow(at: indexPath) as? MenuTableCell else {return}
      //  let menuModel = MenuModel(rawValue: indexPath.row)
      //  cell.iconImageView.image = menuModel?.image
      //  cell.myLabel.text = menuModel?.description
    }
  
}
