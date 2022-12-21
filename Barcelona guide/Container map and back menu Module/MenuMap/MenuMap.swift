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
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableCell.reuseId) as! MenuTableCell
        let menuModel = MenuModel(rawValue: indexPath.row)
        cell.iconImageView.image = menuModel?.image
        cell.myLabel.text = menuModel?.description
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
        presenter.menuConecter(index: indexPath)
    }
}
extension MenuMap: MenuViewProtocol {
    func clouse() {
        print("MenuMap clouse")
    }
}
