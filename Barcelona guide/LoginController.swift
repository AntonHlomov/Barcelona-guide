//
//  LoginController.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2022.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    //MARK: - Properties Headter
    
    // мои добавления и исходный код
    // Описание логотипа, синего фона и зигзага
    
    private let logoContainerView: UIView = {
        let view = UIView()
        let logoImageViw = UIImageView(image: #imageLiteral(resourceName: "icons8-route-30").withRenderingMode(.alwaysOriginal)) // логотип картинка оригинального формата
        let zigzagImageView = UIImageView(image: #imageLiteral(resourceName: "icons8-меню-30").withRenderingMode(.alwaysOriginal)) //зигзаг картинка
    
        
        logoImageViw.contentMode = .scaleAspectFill // что бы картинку "логотип" не растянуло
       
        view.addSubview(zigzagImageView) // отображения картинки "зигзаг"
        view.addSubview(logoImageViw) // отображения картинки "логотип"
        
        zigzagImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0)) // примагничиваем "зигзаг" к краям
        zigzagImageView.centerInSuperview()
        
        logoImageViw.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 50))
        logoImageViw.centerInSuperview()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0)  //rgb(red: 0, green: 120, blue: 175)
        return view
        
    }()
    
    //MARK: - Properties Body
    
    // мои добавления
    // текст Вход
    
    private let textEnter: UILabel = {
       let text = UILabel()
       text.text = "Вход"
       text.font = UIFont .systemFont(ofSize: 44)
    
        return text
    }()
    
    // мои добавления
    // кнопка нет аккаунта Регистрация
    
    private let registrationNewUser: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Регистрация", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.rgb(red: 170, green: 92, blue: 178) ])
       
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(goToSingUP), for: .touchUpInside) // переход на экран регистрации
        
        return button
    }()
    
    
    // Класс из Utils
    // создание текстого поля "Email.."
    
    fileprivate let emailTextfield = UITextField.setupTextField(title: "Электронная почта..", hideText: false, enabled: true)
 
    // создание текстого поля "Password.."
    
    fileprivate let passwordTextField = UITextField.setupTextField(title: "Пароль..", hideText: true, enabled: true)

    // создание кнопку "Войти.."
    
    fileprivate let loginButton = UIButton.setupButton(title: "Enter", color: UIColor.rgb(red: 190, green: 140, blue: 196), activation: false, invisibility: false, laeyerRadius: 12, alpha: 1, textcolor: UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.9))
  
   
    
    
    
    //MARK: - Properties Futer
    
          

    
    
    //кнопка Вход через Factbook
    
    fileprivate let registrationWithFacebook: UIButton = {
        let button = UIButton(type: .system)
        //первая чсть кнопки Вход через Factbook
        let attributedTitle = NSMutableAttributedString(string: "Вход через  ", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.lightGray ])
        //вторая часть кнопки
        attributedTitle.append(NSAttributedString(string: "Facebook", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.rgb(red: 170, green: 92, blue: 178) ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
   
        
        
        return button
    }()
    
 
   
    
   
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
           super.viewDidLoad()
          
           configureViewComponents()
           setupTapGesture()
           handlers()
    
       
       }
    
    
// проверяем поля на заполненность
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
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("Filed to login with error", err.localizedDescription)
                return
        }
            print("Successfuly signed user in")
        
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
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,  size: .init(width: 0, height: 150))
        
        
        
    
        
        // мои добавления стек текста войти и  кнопки регистрации
         let stacUpElementsView =  UIStackView(arrangedSubviews: [textEnter,registrationNewUser])
            stacUpElementsView.axis = .horizontal
            //stacUpElementsView.spacing = 40        // растояние между элементами
            stacUpElementsView.distribution = .fillEqually // расположение  элементов в доли своей оси
             
        view.addSubview(stacUpElementsView)
            stacUpElementsView.anchor(top: logoContainerView.bottomAnchor,// прижимаем к верхнему контенеру к его нижней линии
                              leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,
                              pading: .init(top: 0, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 180))
        
        
        
        
        
        let stackView =  UIStackView(arrangedSubviews: [emailTextfield, passwordTextField, loginButton])
        
            stackView.axis = .vertical
            stackView.spacing = 30        // растояние между элементами
            stackView.distribution = .fillEqually // расположение  элементов в доли своей оси
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor,// прижимаем к верхнему контенеру
                         leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,
                         pading: .init(top: 185, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 180))
        
     
        
        
        
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
