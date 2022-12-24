//
//  ContainerMapAndMenu.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 21/12/2022.
//

import UIKit

class ContainerMapAndMenu: UIViewController {
    var presenter: ContainerMapAndMenuPresenterProtocol!


    override func viewDidLoad() {
        super.viewDidLoad()
  

    }

}
extension ContainerMapAndMenu: ContainerMapProtocol{
    func failure(error: Error) {
        print("error -> ContainerMapAndMenu")
    }

}
