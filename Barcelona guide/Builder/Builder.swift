//
//  Builder.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import UIKit

protocol AsselderBuilderProtocol{
    func createScreensaverModule(router: RouterProtocol) -> UIViewController
    func createMessengerModule(router: RouterProtocol) -> UIViewController
    func createCollectionLocationsModule(router: RouterProtocol) -> UIViewController
    func createRegistrationModule(router: RouterProtocol) -> UIViewController
    func createLoginModule(router: RouterProtocol) -> UIViewController
    func createFavoriteObjectsCollectionModule(router: RouterProtocol) -> UIViewController
    func createPresentansionObjectModule(router: RouterProtocol,user: User?) -> UIViewController
    func createAddNewOjectViewModule(router: RouterProtocol,user: User?) -> UIViewController
    func createChatUsersModule(router: RouterProtocol,user: User?) -> UIViewController
    func createContainerMapAndMenuModule(router: RouterProtocol) -> UIViewController
    
}
class AsselderModelBuilder: AsselderBuilderProtocol{
  
    func createScreensaverModule(router: RouterProtocol) -> UIViewController {
        let view = Screensaver()
        let networkServiceUser = RequestsUserApi()
        let networkServiceMessenger = RequestsMessengerApi()
        let networkServiceHashtag = RequestsCategoryApi()
        let networkServiceObject = RequestsObjectsApi()
        let presenter = ScreensaverPresenter(view: view, networkServiceUser: networkServiceUser,networkServiceSetings: networkServiceMessenger,networkServiceHashtag: networkServiceHashtag,networkServiceObject: networkServiceObject, router:router)
        view.presenter = presenter
        return view
    }
    func createMessengerModule(router: RouterProtocol) -> UIViewController {
        let view = Messenger()
        let networkService = RequestsMessengerApi()
        let presenter = MessengerPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    func createCollectionLocationsModule(router: RouterProtocol) -> UIViewController {
        let view = CollectionLocations(collectionViewLayout: UICollectionViewFlowLayout())
        let networkService = RequestsObjectsApi()
        let presenter = CollectionLocationsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
  
    func createRegistrationModule(router: RouterProtocol) -> UIViewController {
        let view = Registration()
        let networkService = RegistrationApi()
        let presenter = RegistrationPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    func createLoginModule(router: RouterProtocol) -> UIViewController {
        let view = Login()
        let networkService = LoginApi()
        let presenter = LoginPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    func createFavoriteObjectsCollectionModule(router: RouterProtocol) -> UIViewController {
        let view = FavoriteObjectsCollection(collectionViewLayout: UICollectionViewFlowLayout())
        let networkService = RequestsObjectsApi()
        let presenter = FavoriteObjectsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    func createPresentansionObjectModule(router: RouterProtocol,user: User?) -> UIViewController {
        let view = PresentansionObject()
        let networkService = RequestsObjectsApi()
        let presenter = PresentansionObjectPresenter(view: view, networkService: networkService, router: router,user: user)
        view.presenter = presenter
        return view
    }
    func createAddNewOjectViewModule(router: RouterProtocol,user: User?) -> UIViewController{
        let view = AddNewOjectView()
        let networkService = RequestsObjectsApi()
        let networkServiceCategory = RequestsCategoryApi()
        let presenter = AddNewOjectPresenter(view: view, networkService: networkService, networkServiceCategory: networkServiceCategory, router: router,user: user)
        view.presenter = presenter
        return view
    }
    func createChatUsersModule(router: RouterProtocol,user: User?) -> UIViewController{
        let view = ChatUsersControler()
        let networkService = RequestsMessengerApi()
        let presenter = ClientsTabPresentor(view: view,networkService: networkService, router: router,user: user)
        view.presenter = presenter
        return view
    }
    
    func createContainerMapAndMenuModule(router: RouterProtocol) -> UIViewController{
        let view = ContainerMapAndMenu() 
        let viewMapa = Mapa()
        let viewMenuMapa = MenuMap()
        let networkService = RequestsObjectsApi()
        let presenter = ContainerMapAndMenuPresenter(view: view,viewMapa: viewMapa, viewMenuMapa: viewMenuMapa, networkService: networkService, router: router)
        view.presenter = presenter
        viewMapa.presenter = presenter
        viewMenuMapa.presenter = presenter
        view.view.insertSubview(viewMapa.view, at: 1)
        view.addChild(viewMapa)
        view.view.insertSubview(viewMenuMapa.view, at: 0)
        view.addChild(viewMenuMapa)
        return view
    }
    
}
