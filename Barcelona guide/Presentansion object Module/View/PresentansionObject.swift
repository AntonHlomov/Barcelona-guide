//
//  PresentansionObject.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 09/12/2022.
//

import UIKit

class PresentansionObject: UIViewController {
    var presenter: PresentansionObjectPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
extension PresentansionObject: PresentansionObjectProtocol {
    func failure(error: Error){
        
    }
    func reload(){
        
    }
    func alert(title: String, message: String){
        
    }
}
