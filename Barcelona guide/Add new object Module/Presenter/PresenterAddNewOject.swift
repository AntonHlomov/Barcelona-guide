//
//  PresenterAddNewOject.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 12/12/2022.
//

import Foundation
import UIKit


protocol AddNewOjectProtocol: AnyObject{
    
    func failure(error: Error)
    func alert(title: String, message: String)
    func reload()
}

protocol AddNewOjectPresenterProtocol: AnyObject{
    
    init(view: AddNewOjectProtocol, networkService: RequestsObjectsApiProtocol, networkServiceCategory:RequestsCategoryApiProtocol, router:RouterProtocol, user: User?)
    var user: User? {get set}
    var category: [Category]? {get set}
    func getCategory()
    func setData(nameObject: String,categoryObject: String,textObject: String,objectImage: UIImage, longitude: Double, latitude: Double)
    
}

class AddNewOjectPresenter: AddNewOjectPresenterProtocol{

    weak var view: AddNewOjectProtocol?
    let networkService: RequestsObjectsApiProtocol!
    let networkServiceCategory: RequestsCategoryApiProtocol!
    var router: RouterProtocol?
    var user: User?
    var category: [Category]? 
    
    required init(view: AddNewOjectProtocol, networkService: RequestsObjectsApiProtocol, networkServiceCategory:RequestsCategoryApiProtocol, router:RouterProtocol, user: User?) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.networkServiceCategory = networkServiceCategory
        self.user = user
        getCategory()
       
    }
    func getCategory(){
        guard self.user != nil else {return}
        networkServiceCategory.getCategory( ){ [weak self] result in
            guard self != nil else {return}
            DispatchQueue.main.async {
                switch result{
                case .success(let category):
                    self?.category = category
                    self?.view?.reload()
                case .failure(let error):
                    self?.view?.failure(error: error)
                    
                }
            }
        }
        
    }
 
    
    // Upload data
    func setData(nameObject: String,categoryObject: String,textObject: String,objectImage: UIImage, longitude: Double, latitude: Double){
        guard let user = self.user else {return}
         networkService.setObject(nameObject: nameObject,categoryObject: categoryObject,textObject: textObject,objectImage: objectImage, longitude: longitude, latitude: latitude, user: user){ [weak self] result in
            guard self != nil else {return}
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                    self?.view?.alert(title: "The upload.", message: "The upload was successful.")
                    self?.router?.popToRoot()
                case .failure(let error):
                    self?.view?.failure(error: error)
                    
                }
            }
        }
      
    }
    
}

