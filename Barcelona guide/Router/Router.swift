//
//  Router.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import UIKit

protocol RouterLogin{
    var navigationControler: UINavigationController? {get set}
    var assemblyBuilder: AsselderBuilderProtocol? {get set}
}
protocol RouterProtocol: RouterLogin {
    func initalScreensaver()
    func initalLogin()
    func initContainerMapAndMenu()
    func showMessenger()
    func showCollectionLocations()
    func showChatUsers(user: User?)
    func showRegistration()
    func showLogin()
    func showFavoriteObjectsCollection()
    func showPresentansionObject(user: User?)
    func showAddNewOject(user: User?)
    func popToRoot()
    func dismiss()
    func schowLoginMoveToLeft()
    func backTappedFromRight()
}
class Router: RouterProtocol{

    var navigationControler: UINavigationController?
    var assemblyBuilder: AsselderBuilderProtocol?
    
    init(navigationControler: UINavigationController,assemblyBuilder: AsselderBuilderProtocol){
        self.navigationControler = navigationControler
        self.assemblyBuilder = assemblyBuilder
    }
    func initalScreensaver() {
        if let navigationControler = navigationControler{
            guard let mainViewControler = assemblyBuilder?.createScreensaverModule(router: self) else {return}
            navigationControler.viewControllers = [mainViewControler]
        }
    }
    func initalLogin() {
        if let navigationControler = navigationControler{
            guard let mainViewControler = assemblyBuilder?.createLoginModule(router: self) else {return}
            navigationControler.viewControllers = [mainViewControler]
        }
    }
    
    func initContainerMapAndMenu() {
        if let navigationControler = navigationControler{
            guard let mainViewControler = assemblyBuilder?.createContainerMapAndMenuModule(router: self) else {return}
            navigationControler.navigationBar.isHidden = true
            navigationControler.viewControllers = [mainViewControler]
        }
    }
    
    func showMessenger(){
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createMessengerModule(router: self) else {return}
            navigationControler.navigationBar.isHidden = false
            navigationControler.pushViewController(showControler, animated: true)
        }
    }
    
    func showCollectionLocations(){
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createCollectionLocationsModule(router: self) else {return}
            navigationControler.navigationBar.isHidden = true
            navigationControler.pushViewController(showControler, animated: true)
        }
    }

    func showRegistration(){
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createRegistrationModule(router: self) else {return}
            navigationControler.pushViewController(showControler, animated: true)
        }
    }
    
    func showLogin(){
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createLoginModule(router: self) else {return}
            navigationControler.pushViewController(showControler, animated: true)
        }
    }
    
    func showFavoriteObjectsCollection(){
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createFavoriteObjectsCollectionModule(router: self) else {return}
            navigationControler.pushViewController(showControler, animated: true)
        }
    }
    
    func showPresentansionObject(user: User?){
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createPresentansionObjectModule(router: self,user: user) else {return}
            navigationControler.pushViewController(showControler, animated: true)
        }
    }
    func showChatUsers(user: User?){
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createChatUsersModule(router: self,user: user) else {return}
            navigationControler.navigationBar.isHidden = false
            navigationControler.customMove(showControler, subtype: .fromLeft)
            
        }
    }
    func showAddNewOject(user: User?) {
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createAddNewOjectViewModule(router: self,user: user) else {return}
            navigationControler.navigationBar.isHidden = false
            navigationControler.pushViewController(showControler, animated: true)
        }
    }
    
    func popToRoot(){
        if let navigationControler = navigationControler{
            navigationControler.popToRootViewController(animated: true)
        }
    }
   func backTappedFromRight(){
       if let navigationControler = navigationControler{
           navigationControler.customMovePopToRoot(subtype: .fromRight)
       }
   }
    
    func dismiss(){
        if let navigationControler = navigationControler{
            navigationControler.dismiss(animated: true, completion: nil)
        }
    }
    func schowLoginMoveToLeft(){
        if let navigationControler = navigationControler{
            guard let showControler = assemblyBuilder?.createLoginModule(router: self) else {return}
            navigationControler.customMove(showControler, subtype: .fromRight)
        }
    }
}
extension UINavigationController {
   
    func customMove(_ viewController: UIViewController,subtype: CATransitionSubtype ) {
      
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = subtype
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    func customMovePopToRoot(subtype: CATransitionSubtype ) {
      
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = subtype
        view.layer.add(transition, forKey: nil)
        popToRootViewController(animated: true)
    }
}
