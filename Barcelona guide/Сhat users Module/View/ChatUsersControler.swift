//
//  ChatUsersControler.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 18/12/2022.
//

import UIKit

class ChatUsersControler: UITableViewController,UISearchBarDelegate, UICollectionViewDelegateFlowLayout  {
    var presenter: ChatUsersPresenterProtocol!
    let chatUserId = "ChatUserId"
    var searchBar: UISearchBar = {
        let search = UISearchBar()
        return search }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        self.navigationController?.navigationBar.tintColor = UIColor.appColor(.grayPlatinum)
        
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: chatUserId)
        tableView.separatorColor = .clear //линии между ячейками цвет
        tableView.refreshControl = dataRefresher
        

        configureComponents()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       }
    func configureComponents(){
        view.addSubview(searchBar)
        searchBar.anchor(top:  view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,pading: .init(top: 20, left: 0, bottom: 0, right: 0))
  
        
    // self.tableView.anchor(top: searchBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,pading: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    func serchBarChats(){
        searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.tintColor = UIColor.appColor(.grayMidle)
        searchBar.barTintColor = UIColor.appColor(.bluePewter)
        searchBar.barStyle = .black
        searchBar.backgroundColor = UIColor.appColor(.bluePewter)
        searchBar.sizeToFit()
        searchBar.searchTextField.backgroundColor = UIColor.appColor(.grayPlatinum)
        let textField = searchBar.value(forKey: "searchField") as! UITextField
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        glassIconView.tintColor = UIColor.appColor(.pinkLightSalmon)
        
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //presenter.filterChatUsers?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      85
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatUserId, for: indexPath) as! ChatUserCell
        cell.backgroundColor =  UIColor.appColor(.bluePewter)
        cell.chatUser = presenter.filterChatUsers?[indexPath.row]
        cell.accessoryType = .disclosureIndicator
       // cell.addCustomDisclosureIndicator(with: UIColor.appColor(.grayPlatinum)!)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.goToChatUser(indexPathRowChatUser: indexPath.row)
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        // Создать константу для работы с кнопкой
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            print("Delete")
          //  self?.presenter.deleteClient(indexPath: indexPath)
            self!.tableView.deleteRows(at: [indexPath], with: .top)
        }
     
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.appColor(.pinkLightSalmon)?.withAlphaComponent(0.3)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 60))
        footerView.backgroundColor = UIColor.appColor(.bluePewter)
        serchBarChats()
        footerView.addSubview(self.searchBar)
        
        return footerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    // MARK: - SearchResults
    func updateSearchResults(for searchController: UISearchController) {
        print("filter works")
        presenter.filter(text: searchController.searchBar.text!)
    }
    // MARK: - Refresher
    lazy var dataRefresher : UIRefreshControl = {
        let myRefreshControl = UIRefreshControl()
        myRefreshControl.tintColor =  .white
        myRefreshControl.backgroundColor = UIColor.appColor(.bluePewter)
        myRefreshControl.addTarget(self, action: #selector(updateMyCategory), for: .valueChanged)
    return myRefreshControl
    }()
    @objc func updateMyCategory() {
        presenter.getChatUsers()
        // EndRefreshing
        dataRefresher.endRefreshing()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Ready", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
       // presenter.filter(text: searchText)
        print(searchText)
    }
  
}
extension ChatUsersControler{
    func alertRegistrationControllerMassage(title: String, message: String){
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        alertControler.addAction(alertOk)
        present(alertControler, animated: true, completion: nil)
    }
}
//связывание вью с презентером что бы получать от него ответ и делать какие то действия в вью
extension ChatUsersControler: ChatUsersProtocol {
    func succesReload() {
        tableView.reloadData()
    }
    func failure(error: Error) {
        let error = "\(error.localizedDescription)"
        alertRegistrationControllerMassage(title: "Error", message: error)
    }
}
