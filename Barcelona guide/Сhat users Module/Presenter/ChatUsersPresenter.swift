//
//  ChatUsersPresenter.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 18/12/2022.
//

import Foundation

protocol ChatUsersProtocol: AnyObject {
    func succesReload()
    func failure(error: Error)
}

protocol ChatUsersPresenterProtocol: AnyObject {
    init(view: ChatUsersProtocol,networkService: RequestsMessengerApiProtocol, router: RouterProtocol,user: User?)
    func getChatUsers()
    func filter(text: String)
   // func deleteClient(indexPath: IndexPath)
   // func redactClient(indexPath: IndexPath)
   // var user: User? { get set }
    var chatUsers: [ChatUser]? {get set}
    var filterChatUsers: [ChatUser]? {get set}
    func goToChatUser(indexPathRowChatUser:Int)
   // func goToAddClient()
}

class ClientsTabPresentor: ChatUsersPresenterProtocol {
   
    weak var view: ChatUsersProtocol?
    var router: RouterProtocol?
    let networkService:RequestsMessengerApiProtocol!
    var chatUsers: [ChatUser]?
    var filterChatUsers: [ChatUser]?
    var user: User?
   // var markAddMassageReminder: Bool

    required init(view: ChatUsersProtocol,networkService: RequestsMessengerApiProtocol, router: RouterProtocol,user: User?) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.user = user
        //  self.markAddMassageReminder = markAddMassageReminder
        //   getClients()
    }
    
    func deleteClient(indexPath: IndexPath){
      /*
        guard let ref = self.filterChatUsers?[ indexPath.row].displayProfileImageUser else {return}
        guard let id = self.filterChatUsers?[ indexPath.row].userId else {return}
        self.chatUsers?.remove(at: indexPath.row)
        self.filterChatUsers?.remove(at: indexPath.row)
        networkService.deleteChatUser(id: id, reference: ref, user: self.user) {[weak self] result in
        guard let self = self else {return}
            DispatchQueue.main.async {
                switch result{
                case.success(_):
                    print("delete")
                case.failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
      */
    }
    func filter(text: String) {
        if text == "" {
            filterChatUsers = chatUsers?.sorted{ $0.displayName < $1.displayName } }
        else {
            filterChatUsers = chatUsers?.filter( {$0.displayName.lowercased().contains(text.lowercased()) || $0.displayFullName.lowercased().contains(text.lowercased())})
        }
        self.view?.succesReload()
    }
    func getChatUsers() {
   
  //      networkService.getClients(user: self.user){ [weak self] result in
  //          guard self != nil else {return}
  //          DispatchQueue.main.async {
  //              switch result{
  //              case .success(let clients):
  //                  self?.clients = clients?.sorted{ $0.nameClient < $1.nameClient}
  //                  self?.filterClients = self?.clients
  //                  self?.view?.succesReload()
  //              case .failure(let error):
  //                  self?.view?.failure(error: error)
  //
  //              }
  //          }
  //      }
       
    }
    func goToChatUser(indexPathRowChatUser:Int) {
        self.router?.showMessenger()
      //  self.router?.showClientPage(client: filterChatUsers?[indexPathRowClient], user1: self.user, user2: self.user,)
    }
    func goToAddClient() {
      //  self.router?.showAddClientView(editMode: false, client: nil, user: self.user)
    }
    func redactClient(indexPath: IndexPath){
      //  self.router?.showAddClientView(editMode: true, client:  self.filterClients?[indexPath.row], user: self.user)
    }
}
