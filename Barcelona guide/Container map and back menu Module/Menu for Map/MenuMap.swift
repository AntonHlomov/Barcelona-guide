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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        configureTableView()
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
        tableView.backgroundColor = .darkGray
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
    func setDataButtonMenu(indexPath: IndexPath){
        print("setDataButtonMenu")
      //  guard var cell = self.tableView.cellForRow(at: indexPath) as? MenuTableCell else {return}
      //  let menuModel = MenuModel(rawValue: indexPath.row)
      //  cell.iconImageView.image = menuModel?.image
      //  cell.myLabel.text = menuModel?.description
    }
  
}
