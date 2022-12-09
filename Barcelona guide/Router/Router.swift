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
    
    func dismiss()
}
class Router: RouterProtocol{
    var navigationControler: UINavigationController?
    var assemblyBuilder: AsselderBuilderProtocol?
    
    init(navigationControler: UINavigationController,assemblyBuilder: AsselderBuilderProtocol){
        self.navigationControler = navigationControler
        self.assemblyBuilder = assemblyBuilder
    }
    
    func dismiss() {
        if let navigationControler = navigationControler{
            navigationControler.dismiss(animated: true, completion: nil)
        }
    }
}
