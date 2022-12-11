//
//  Settings.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import UIKit

class Settings: UIViewController {
    var presenter: SettingsPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.appColor(.grayPlatinum)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func backTapped() {
        presenter.goToBack()
    }

}
extension Settings: SettingsProtocol {
    func failure(error: Error){
        
    }
    func alert(title: String, message: String){
        
    }
}
