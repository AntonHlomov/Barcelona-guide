//
//  CheckUserController.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2022.
//

import UIKit
import Firebase

class CheckUserController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        ifUserLoginIn ()
    }
    //функция проверки регистрации если не зарегстрирован, то открыть окно логин
    fileprivate func ifUserLoginIn (){
        
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let loginVC = LoginController()
                let navControler = UINavigationController(rootViewController: loginVC)
                navControler.modalPresentationStyle = .fullScreen
                self.present(navControler, animated: true, completion: nil)
            }
        } else {
            let loginVC = ViewController()
            let navControler = UINavigationController(rootViewController: loginVC)
            navControler.modalPresentationStyle = .fullScreen
            self.present(navControler, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
