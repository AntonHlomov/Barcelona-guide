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
    func createSettingsModule(router: RouterProtocol) -> UIViewController
    func createCollectionLocationsModule(router: RouterProtocol) -> UIViewController
    func createMapaModule(router: RouterProtocol) -> UIViewController
    func createRegistrationModule(router: RouterProtocol) -> UIViewController
    func createLoginModule(router: RouterProtocol) -> UIViewController
    func createFavoriteObjectsCollectionModule(router: RouterProtocol) -> UIViewController
    func createPresentansionObjectModule(router: RouterProtocol,user: User?) -> UIViewController
    
}
class AsselderModelBuilder: AsselderBuilderProtocol{
    func createScreensaverModule(router: RouterProtocol) -> UIViewController {
        let view = Screensaver()
        let networkServiceUser = RequestsUserApi()
        let networkServiceSetings = RequestsSetingsApi()
        let networkServiceHashtag = RequestsHashtagApi()
        let networkServiceObject = RequestsObjectsApi()
        let presenter = ScreensaverPresenter(view: view, networkServiceUser: networkServiceUser,networkServiceSetings: networkServiceSetings,networkServiceHashtag: networkServiceHashtag,networkServiceObject: networkServiceObject, router:router)
        view.presenter = presenter
        return view
    }
    func createSettingsModule(router: RouterProtocol) -> UIViewController {
        let view = Settings()
        let networkService = RequestsSetingsApi()
        let presenter = SettingsPresenter(view: view, networkService: networkService, router: router)
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
    func createMapaModule(router: RouterProtocol) -> UIViewController {
        let view = Mapa()
        let networkService = RequestsObjectsApi()
        let presenter = MapaPresenter(view: view, networkService: networkService, router: router)
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
    
}
