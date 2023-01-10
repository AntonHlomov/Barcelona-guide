//
//  RegistrationController.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/01/2022.
//

import UIKit
import Firebase

class RegistrationController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var gradePicker: UIPickerView!
    
    //MARK: - Propartes
    var imageSelected = false
    fileprivate let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить фото", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.rgb(red: 31, green: 152, blue: 233) .cgColor
        button.addTarget(RegistrationController.self, action: #selector(selectPhoto), for: .touchUpInside)
        return button
    }()

    @objc fileprivate func selectPhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
 
    fileprivate let emailTexfield = UITextField.setupTextField(title: "Элекетронная почта..", hideText: false, enabled: true)
    fileprivate let fullNameTexfield = UITextField.setupTextField(title: "Имя..", hideText: false, enabled: true)
    fileprivate let shurnameNameTexfield = UITextField.setupTextField(title: "Фамилия..", hideText: false, enabled: true)
    fileprivate let passwordTexfield = UITextField.setupTextField(title: "Пароль..", hideText: true, enabled: true)
    fileprivate let sigUpButton =    UIButton.setupButton(title: "Registration", color: UIColor.rgb(red: 190, green: 140, blue: 196), activation: false, invisibility: false, laeyerRadius: 12, alpha: 1, textcolor: UIColor.rgb(red: 255, green: 255, blue: 255).withAlphaComponent(0.9))

    fileprivate let allRedyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "У меня есть аккаунт  ", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.lightGray ])
        attributedTitle.append(NSAttributedString(string: "вернуться", attributes: [.font:UIFont.systemFont (ofSize: 18), .foregroundColor: UIColor.rgb(red: 170, green: 92, blue: 178) ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(RegistrationController.self, action: #selector(goToSingIn), for: .touchUpInside)
        return button
    }()
    lazy var stackView = UIStackView(arrangedSubviews: [emailTexfield,fullNameTexfield,shurnameNameTexfield,passwordTexfield,sigUpButton])


    override func viewDidLoad() {
        super.viewDidLoad()
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
        selectPhotoButton.layer.backgroundColor = UIColor.black.cgColor
        selectPhotoButton.layer.borderWidth = 2
        selectPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        imageSelected = true
        formValidation()
        self.dismiss(animated: true, completion: nil)
    }

    fileprivate func hadleres() {
        emailTexfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        fullNameTexfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        shurnameNameTexfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTexfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        selectPhotoButton.addTarget(self, action: #selector(formValidation), for: .touchUpInside)
        sigUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
      
    }
    
    @objc fileprivate func handleSignUp(){
        self.handleTapDismiss() //при нажатии кнопки регистрация убераеться клава
        guard let email = emailTexfield.text?.lowercased() else {return}
        guard let password = passwordTexfield.text else {return}
        guard let fullName = fullNameTexfield.text else {return}
        guard let shurname = shurnameNameTexfield.text?.lowercased() else {return}
        //регистрируем в Fairebase
        Auth.auth().createUser(withEmail: email, password: password) { [self] (user, err) in
            if let err = err {
                print(err.localizedDescription)
                alertRegistrationControllerMassage(title: "Oops", message: "\(err.localizedDescription)")
            }
            print("Пользователь успешно создан")
            //загрузка фото в базу данных
            guard let profileImage = self.selectPhotoButton.imageView?.image else {return}
            //качество фото при загрузка в базу данных
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
            //NSUUID() -  это рандомное имя
            let filName = NSUUID().uuidString
            //код загрузки фото
            let storageRef = Storage.storage().reference().child("user_profile_image").child(filName)
            storageRef.putData(uploadData, metadata: nil) { [self]  (_, err) in
                if let err = err {
                    print( "Не удалось загрузить фотографию пользователя! \(err.localizedDescription)")
                    alertRegistrationControllerMassage(title: "Oops", message: "\(err.localizedDescription)")
                    return
                }
                print("Загрузка фотографии пользователя прошла успешно!")
                //получаем обратно адрес картинки
                storageRef.downloadURL { (downLoardUrl, err) in
                    guard let profileImageUrl = downLoardUrl?.absoluteString else {return}
                   if let err = err {
                    print(err.localizedDescription)
                    print("profile is nil")
                       self.alertRegistrationControllerMassage(title: "Oops", message: "\(err.localizedDescription)")
                    return
                }
                    print("Успешна получина ссылка на картинку")
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    //загрузка данных по выручки и пибыли
              
                    let docData = ["uid": uid,"name": fullName, "shurname": shurname, "profileImageUrl": profileImageUrl]
        
                    Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                        if let err = err {
                            print("Failed", err.localizedDescription)
                            self.alertRegistrationControllerMassage(title: "Oops", message: "\(err.localizedDescription)")
                            return
                    }
                        print("Успешна сохранены данные")
                      //  alertRegistrationControllerMassage(title: "Hello", message: "Successfuly signed user in")
                        if Auth.auth().currentUser != nil{
                            DispatchQueue.main.async {
                                let checkVC = CheckUserController() //WorkingDaysController()
                                let navControler = UINavigationController(rootViewController: checkVC)
                                navControler.modalPresentationStyle = .fullScreen
                                self.present(navControler, animated: true, completion: nil)
                            }
                         return
                     }
                  }
               }
            }
        }
    }
     //проверка заполнености полей
    @objc fileprivate func formValidation(){
    guard
          emailTexfield.hasText,
          fullNameTexfield.hasText,
          shurnameNameTexfield.hasText,
          passwordTexfield.hasText,
          imageSelected == true
    else {
        sigUpButton.isEnabled = false
        sigUpButton.backgroundColor = UIColor.rgb(red: 190, green: 140, blue: 196)
          return
        }
        sigUpButton.isEnabled = true
        sigUpButton.backgroundColor = UIColor.rgb(red: 170, green: 92, blue: 178)
    }
    
    fileprivate func configureViewComponents(){
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true   //что бы не появлялся навигейшен бар

        view.addSubview(selectPhotoButton)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, pading: .init(top: view.frame.height/13, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.height/3.9, height: view.frame.height/3.9))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
        selectPhotoButton.layer.cornerRadius = view.frame.height/3.9 / 2
 
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually  // для корректного отображения
        view.addSubview(stackView)
        stackView.anchor(top: selectPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, pading: .init(top: 50, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: view.frame.height/3))
        
        view.addSubview(allRedyHaveAccountButton)
        allRedyHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 40, bottom: 0, right: 40))  // view.safeAreaLayoutGuide.bottomAnchor что бы неуходила ниже подвала
    }
    //MARK: - проверка
    //функция проверки регистрации если не зарегстрирован, то открыть окно логин
    fileprivate func ifUserLoginIn (){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let loginVC = LoginController()
                let navControler = UINavigationController(rootViewController: loginVC)
                navControler.modalPresentationStyle = .fullScreen
                self.present(navControler, animated: true, completion: nil)
            }
         return
        }
    }
    
    @objc fileprivate func goToSingIn(){
        dismiss(animated: true, completion: nil)
    }
    //MARK: - Клавиатура
    fileprivate func  setupNotificationObserver(){
        // следит когда подниметься клавиатура
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // следит когда пbcxtpftn
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwowHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   override func viewWillDisappear(_ animated: Bool) {      //очищает клавиатуру из памяти обязательно делать если вызываешь клаву
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
extension RegistrationController{
    func alertRegistrationControllerMassage(title: String, message: String){
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        alertControler.addAction(alertOk)
        present(alertControler, animated: true, completion: nil)
    }
}
