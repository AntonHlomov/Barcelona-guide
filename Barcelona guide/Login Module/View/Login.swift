//
//  Login.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import UIKit

class Login: UIViewController {
    var presenter: LoginPresenterProtocol!
    //MARK: - Properties Body
    private let textEnter: UILabel = {
        let text = UILabel()
        text.text = "Login"
        text.textColor = UIColor.appColor(.grayPlatinum)
        text.font = UIFont .systemFont(ofSize: 40)
       return text
    }()
  
    fileprivate let emailTextfield = UITextField.setupTextField(title: "Email..", hideText: false, enabled: true)
    
    fileprivate let passwordTextField = UITextField.setupTextField(title: "Password..", hideText: true, enabled: true)
    
    fileprivate let loginButton = UIButton.setupButton(title: "Enter", color:  UIColor.appColor(.redLightSalmon)!, activation: false, invisibility: false, laeyerRadius: 12, alpha: 1, textcolor: UIColor.appColor(.grayPlatinum)!)
    
    fileprivate let registrationButton = UIButton.setupButton(title: "Registration", color:  UIColor.appColor(.redLightSalmon)!, activation: true, invisibility: false, laeyerRadius: 12, alpha: 0.5, textcolor: UIColor.appColor(.grayPlatinum)!)
    
    fileprivate let registrationWithApple: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Sign in with  ", attributes: [.font:UIFont.boldSystemFont (ofSize: 18), .foregroundColor: UIColor.appColor(.grayPlatinum)! ])
        attributedTitle.append(NSAttributedString(string: "Apple", attributes: [.font:UIFont.boldSystemFont (ofSize: 18), .foregroundColor: UIColor.appColor(.redLightSalmon)! ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    lazy var stacUpElementsView =  UIStackView(arrangedSubviews: [textEnter])
    lazy var stackView =  UIStackView(arrangedSubviews: [emailTextfield, passwordTextField, loginButton,registrationButton])
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapDismiss), name: UIApplication.willResignActiveNotification, object:nil)
      //  navigationController?.navigationBar.isHidden = true // скрыть навигейшн бар
        configureViewComponents()
        setupNotificationObserver()
        setupTapGesture()
        handlers()
    }
    // MARK: - ConfigureView
    fileprivate func configureViewComponents(){

        stacUpElementsView.axis = .horizontal
        stacUpElementsView.distribution = .fillEqually
        
        view.addSubview(stacUpElementsView)
        stacUpElementsView.anchor(top: view.safeAreaLayoutGuide.topAnchor,leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,pading: .init(top: view.frame.height/6, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 44))
        stackView.axis = .vertical
        stackView.spacing = view.frame.height/25
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: stacUpElementsView.bottomAnchor,leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,pading: .init(top: view.frame.height/20, left: 20, bottom: 0, right:20), size: .init(width: 0, height: view.frame.height/3.2))
        
        // определяем кнопку зайти через фесбук
        view.addSubview(registrationWithApple)
        registrationWithApple.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 40, bottom: 10, right: 40))
    }
    // MARK: - Handlers
    fileprivate func handlers(){
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged )
        emailTextfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(goToRegistration), for: .touchUpInside)
        registrationWithApple.addTarget(self, action: #selector(goToRegistrationWithApple), for: .touchUpInside)
        
    }
    @objc fileprivate func handleLogin() {
        guard let email = emailTextfield.text else {return}
        guard let password = passwordTextField.text else {return}
        // говорим презентеру на меня тапнули сделай эту бизнес логику
        self.presenter.authorisation(emailAuth: email, passwordAuth: password)
        self.loginButton.isEnabled = false
        self.loginButton.backgroundColor = UIColor.appColor(.redLightSalmon)
    }
    @objc fileprivate func formValidation() {
        guard
            passwordTextField.hasText,
            emailTextfield.hasText
        else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = UIColor.appColor(.redLightSalmon)
            return
        }
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.appColor(.redDarkSalmon)
    }
    
    @objc fileprivate func goToRegistrationWithApple(){
       presenter.goToRegistrationWithApple()
    }
    @objc fileprivate func goToRegistration(){
       presenter.goToRegistarasionControler()
    }
    // MARK: - Keyboard
    fileprivate func  setupNotificationObserver(){
        // следит когда подниметься клавиатура
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // следит когда пbcxtpftn
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwowHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       AppUtility.lockOrientation(.portrait)
       // Or to rotate and lock
   }
    override func viewWillDisappear(_ animated: Bool) {      //очищает клавиатуру из памяти обязательно делать если вызываешь клаву
         super.viewWillDisappear(animated)
         NotificationCenter.default.removeObserver(self)
        AppUtility.lockOrientation(.all)
     }
    //размеры клавиатуры
    @objc fileprivate func handleKeyboardSwow(notification: Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardframe = value .cgRectValue    //рамка клавиатуры
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height        //на сколько должна сдвинуть интерфейс
        let difference = keyboardframe.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 15)
    }
    //опускание клавиатуры
    @objc fileprivate func handleKeyboardSwowHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity     // интерфейс опускаеться в низ
        }, completion: nil)
    }
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    @objc fileprivate func handleTapDismiss(){
        view.endEditing(true)
    }
}
extension Login: LoginProtocol {
    func failure(error: Error){
        let error = "\(error.localizedDescription)"
        alertError(title: "Error", message: error)
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.appColor(.redDarkSalmon)
    }
    func alert(title: String, message: String){
        alertMessage(title: title, message: message)
    }
}
