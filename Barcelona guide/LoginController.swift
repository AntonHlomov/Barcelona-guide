//
//  LoginController.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2022.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    private let textEnter: UILabel = {
       let text = UILabel()
       text.text = "Вход"
       text.font = UIFont .systemFont(ofSize: 44)
       return text
    }()

    private let registrationNewUser: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Регистрация", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.rgb(red: 170, green: 92, blue: 178) ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(goToSingUP), for: .touchUpInside)
        return button
    }()
  
    fileprivate let emailTextfield = UITextField.setupTextField(title: "Электронная почта..", hideText: false, enabled: true)
    fileprivate let passwordTextField = UITextField.setupTextField(title: "Пароль..", hideText: true, enabled: true)
    fileprivate let loginButton = UIButton.setupButton(title: "Enter", color: UIColor.rgb(red: 190, green: 140, blue: 196), activation: false, invisibility: false, laeyerRadius: 12, alpha: 1, textcolor: UIColor.rgb(red: 255, green: 255, blue: 255).withAlphaComponent(0.9))
  
    fileprivate let registrationWithFacebook: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Вход через  ", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.lightGray ])
        attributedTitle.append(NSAttributedString(string: "Facebook", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.rgb(red: 170, green: 92, blue: 178) ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    lazy var stacUpElementsView =  UIStackView(arrangedSubviews: [textEnter,registrationNewUser])
    lazy var stackView =  UIStackView(arrangedSubviews: [emailTextfield, passwordTextField, loginButton])
    
    override func viewDidLoad() {
           super.viewDidLoad()
           configureViewComponents()
           setupTapGesture()
           handlers()
       }

    fileprivate func handlers(){
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged )
        emailTextfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    // переход на на основную страницу приложения maindTabVcControler
    //функционал авторизации
    @objc fileprivate func handleLogin() {
        guard let email = emailTextfield.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] (user, err) in
            if let err = err {
                print("Filed to login with error", err.localizedDescription)
                alertLoginControllerMassage(title: "Oops", message: "\(err.localizedDescription)")
                return
        }
            print("Successfuly signed user in")
           // alertLoginControllerMassage(title: "Hello", message: "Successfuly signed user in")
            
           let loginVC = ViewController()
           let navControler = UINavigationController(rootViewController: loginVC)
           navControler.modalPresentationStyle = .fullScreen
           self.present(navControler, animated: true, completion: nil)
            
         //   // переход с удалением предыдущего контролера
         //   DispatchQueue.main.async {
       //
         //       let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
         //       if let maintabVC = keyWindow?.rootViewController as? ViewController {
         //
         //        }
         //       self.dismiss(animated: true, completion: nil)
         //   }
       //
    }
}
    // проверяем поля на заполненность
    @objc fileprivate func formValidation() {
        guard
            passwordTextField.hasText,
            emailTextfield.hasText
        else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = UIColor.rgb(red: 190, green: 140, blue: 196)
            return
        }
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.rgb(red: 170, green: 92, blue: 178)
    }
    //MARK: - configureViewComponents
    fileprivate func configureViewComponents(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true // скрыть навигейшн бар
         
        stacUpElementsView.axis = .horizontal
        //stacUpElementsView.spacing = 40
        stacUpElementsView.distribution = .fillEqually
             
        view.addSubview(stacUpElementsView)
        stacUpElementsView.anchor(top:view.safeAreaLayoutGuide.topAnchor,leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,pading: .init(top: view.frame.height/5, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 40))
        
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: stacUpElementsView.bottomAnchor,leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,pading: .init(top: 45, left: 20, bottom: 0, right:20), size: .init(width: 0, height: view.frame.height/4))
        
       // определяем кнопку зайти через фесбук
       view.addSubview(registrationWithFacebook)
       registrationWithFacebook.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 40, bottom: 10, right: 40))
    }
    
    @objc fileprivate func goToSingUP(){
        
         let signUpcontroller = RegistrationController()
         let navController = UINavigationController(rootViewController: signUpcontroller)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
}

    // MARK: - Keyboard
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    @objc fileprivate func handleTapDismiss(){
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginController{
    func alertLoginControllerMassage(title: String, message: String){
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        alertControler.addAction(alertOk)
        present(alertControler, animated: true, completion: nil)
    }
}
