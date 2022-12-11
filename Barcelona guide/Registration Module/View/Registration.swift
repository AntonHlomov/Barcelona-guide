//
//  Registration.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import UIKit

class Registration: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var presenter: RegistrationPresenterProtocol!
    var indicatorLogin = false
    // подключаемся к презентеру через протокол чтобы передавать нажатия итд из этого view
    var gradePicker: UIPickerView!
//MARK: - Propartes
    var imageSelected = false
    fileprivate let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = UIColor.appColor(.grayPlatinum)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    @objc fileprivate func selectPhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    fileprivate let emailTexfield = UITextField.setupTextField(title: "Email..", hideText: false, enabled: true)
    fileprivate let nameTexfield = UITextField.setupTextField(title: "Name..", hideText: false, enabled: true)
    fileprivate let passwordTexfield = UITextField.setupTextField(title: "Password..", hideText: true, enabled: true)
    fileprivate let sigUpButton =    UIButton.setupButton(title: "Registration", color: UIColor.appColor(.redLightSalmon)!, activation: false, invisibility: false, laeyerRadius: 12, alpha: 1, textcolor: UIColor.appColor(.grayPlatinum)!)
    fileprivate let allRedyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "I have an account  ", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.appColor(.grayPlatinum)! ])
        attributedTitle.append(NSAttributedString(string: "return", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.appColor(.redLightSalmon)! ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    lazy var stackView = UIStackView(arrangedSubviews: [emailTexfield,nameTexfield,passwordTexfield,sigUpButton])
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        navigationController?.navigationBar.isHidden = true   //что бы не появлялся навигейшен бар
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapDismiss), name: UIApplication.willResignActiveNotification, object:nil)
        configureViewComponents()
        setupNotificationObserver()
        setupTapGesture()
        hadleres()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        selectPhotoButton.layer.cornerRadius = selectPhotoButton.frame.width / 2
        selectPhotoButton.layer.masksToBounds = true
        selectPhotoButton.layer.backgroundColor = UIColor.appColor(.grayPlatinum)!.cgColor
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.borderColor = UIColor.appColor(.grayPlatinum)!.cgColor
        selectPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        imageSelected = true
        formValidation()
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func hadleres() {
        emailTexfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        nameTexfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTexfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        selectPhotoButton.addTarget(self, action: #selector(formValidation), for: .touchUpInside)
        sigUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        selectPhotoButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        allRedyHaveAccountButton.addTarget(self, action: #selector(goToSingIn), for: .touchUpInside)
    }
    @objc fileprivate func handleSignUp(){
        guard let email = emailTexfield.text?.lowercased() else {return}
        guard let password = passwordTexfield.text else {return}
        guard let name = nameTexfield.text else {return}
        guard let profileImage = self.selectPhotoButton.imageView?.image else {return}
        print("проверка данных для регистрации")
        handleTapDismiss()
        sigUpButton.isEnabled = false
        sigUpButton.backgroundColor = UIColor.appColor(.redLightSalmon)!
        self.presenter.setRegistrationInformation(photoUser: profileImage, emailAuth: email, name: name, passwordAuth: password)
    }
     //проверка заполнености полей
    @objc fileprivate func formValidation(){
    guard
          emailTexfield.hasText,
          nameTexfield.hasText,
          passwordTexfield.hasText,
          imageSelected == true
    else {
        sigUpButton.isEnabled = false
        sigUpButton.backgroundColor = UIColor.appColor(.redLightSalmon)!
          return
        }
        sigUpButton.isEnabled = true
        sigUpButton.backgroundColor = UIColor.appColor(.redDarkSalmon)!
    }
    fileprivate func configureViewComponents(){
        view.addSubview(selectPhotoButton)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: view.frame.height/13, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.height/3.9, height: view.frame.height/3.9))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
        selectPhotoButton.layer.cornerRadius = view.frame.height/3.9 / 2
 
        stackView.axis = .vertical
        stackView.spacing = view.frame.height/35
        stackView.distribution = .fillEqually  // для корректного отображения
        view.addSubview(stackView)
        stackView.anchor(top: selectPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, pading: .init(top: view.frame.height/12, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: view.frame.height/3.6))
        
        view.addSubview(allRedyHaveAccountButton)
        allRedyHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 40, bottom: 10, right: 40))  // view.safeAreaLayoutGuide.bottomAnchor что бы неуходила ниже подвала
    }
    //MARK: - проверка
    //функция проверки регистрации если не зарегстрирован, то открыть окно логин
    fileprivate func ifUserLoginIn (){
    }
    @objc fileprivate func goToSingIn(){
        presenter.goToLoginControler()
    }
//MARK: - Keyboard
    fileprivate func  setupNotificationObserver(){
        // listener up keybord
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // listener down keybord
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwowHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       AppUtility.lockOrientation(.portrait)
       // Or to rotate and lock
   }
   override func viewWillDisappear(_ animated: Bool) {
       //clean keybord from memoey
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        AppUtility.lockOrientation(.all)
    }
    //frame keybord
    @objc fileprivate func handleKeyboardSwow(notification: Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        //frame keybord
        let keyboardframe = value .cgRectValue
        //how high moving the window be
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardframe.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(-difference) - 15)
    }
    //down keybord
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
extension Registration: RegistrationProtocol {
    func failure(error: Error){
        let error = "\(error.localizedDescription)"
        alertError(title: "Error", message: error)
        sigUpButton.isEnabled = true
        sigUpButton.backgroundColor = UIColor.appColor(.redDarkSalmon)!
    }
    func alert(title: String, message: String){
        alertMessage(title: title, message: message)
    }
}
