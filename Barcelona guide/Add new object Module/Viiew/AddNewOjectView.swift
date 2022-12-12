//
//  AddNewOjectView.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 12/12/2022.
//

import UIKit
import CoreLocation


class AddNewOjectView:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate {

    var presenter: AddNewOjectPresenterProtocol!
    var locationManager = CLLocationManager()
    var userLongitude: CLLocationDegrees!
    var userLatitude: CLLocationDegrees!

    var imageSelected = false
    var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "foto"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true
        button.tintColor = UIColor(white: 1, alpha: 0.5)
        return button
    }()
    fileprivate let categoryObject = UITextField.setupTextField(title: "Сhoose category..", hideText: false, enabled: true)
    fileprivate let nameObject = UITextField.setupTextField(title: "Item name...", hideText: false, enabled: true)
    fileprivate let textObject = UITextField.setupTextField(title: "Сommentary..", hideText: false, enabled: true)
    fileprivate let publishButton =    UIButton.setupButton(title: "Рublish", color: UIColor.appColor(.pinkLightSalmon)!, activation: false, invisibility: false, laeyerRadius: 12, alpha: 0.7, textcolor: UIColor.appColor(.grayPlatinum)!)
    lazy var stackView = UIStackView(arrangedSubviews: [categoryObject,nameObject,textObject])

    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        self.navigationController?.navigationBar.tintColor = UIColor.appColor(.bluePewter)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        configureViewComponents()
        setupTapGesture()
        hadleres()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapDismiss), name: UIApplication.willResignActiveNotification, object:nil)
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    }
    fileprivate func configureViewComponents(){
        view.addSubview(publishButton)
        publishButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 20, bottom: 5, right: 20), size: .init(width: 0, height: 40))
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: publishButton.topAnchor, trailing:  view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 20, bottom: view.frame.height/8, right: 20), size: .init(width: 0, height: view.frame.height/3))
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.axis = .vertical
        stackView.spacing = view.frame.height/35
        stackView.distribution = .fillEqually  // для корректного отображения
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: stackView.topAnchor, trailing:  view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 20, bottom: 40, right: 20), size: .init(width: 0, height: view.frame.height/4.3))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading:  view.safeAreaLayoutGuide.leadingAnchor, bottom: stackView.topAnchor, trailing:  view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 20, bottom: 40, right: 20), size: .init(width: stackView.frame.width, height: stackView.frame.width))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
        selectPhotoButton.layer.cornerRadius = 12
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
   /*
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading:  view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing:  view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: view.frame.height/15, left: 20, bottom: 0, right: 20), size: .init(width: view.frame.height/6.5, height: view.frame.height/6.5))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
        selectPhotoButton.layer.cornerRadius = view.frame.height/7 / 2
        view.addSubview(addButton)
        addButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 20, bottom: 5, right: 20), size: .init(width: 0, height: 40))
        stackView.axis = .vertical
        stackView.spacing = view.frame.height/35
        stackView.distribution = .fillEqually  // для корректного отображения
        view.addSubview(stackView)
        stackView.anchor(top: selectPhotoButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing:  view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: view.frame.height/3))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    */
    }
    fileprivate func hadleres() {
        categoryObject.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        nameObject.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        textObject.addTarget(self, action: #selector(formValidation), for: .editingChanged)
      //  priceExpenses.keyboardType = .decimalPad
        publishButton.addTarget(self, action: #selector(addService), for: .touchUpInside)
        selectPhotoButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
    }
    @objc fileprivate func formValidation(){
        guard
            categoryObject.hasText,
            nameObject.hasText,
            textObject.hasText
        else {
            publishButton.isEnabled = false
            publishButton.backgroundColor = UIColor.appColor(.redLightSalmon)!.withAlphaComponent(0.7)
            return
            }
        publishButton.isEnabled = true
        publishButton.backgroundColor = UIColor.appColor(.redDarkSalmon)
        }
    //MARK: - Add expenses
    @objc fileprivate func addService(){
        self.handleTapDismiss()
        guard let category = categoryObject.text?.lowercased() else {return}
        guard let name = nameObject.text?.lowercased() else {return}
        guard let text = textObject.text?.lowercased() else {return}
      //  guard let priceExpenses = priceExpenses.text?.doubleValue else {return}
        guard let imageСheck = self.selectPhotoButton.imageView?.image else {return}
        //  User location
        guard  let sourcelocationLongitude = self.userLongitude else {return}
        guard let sourcelocationLatitude = self.userLatitude else {return}
        presenter.setData(nameObject: name, categoryObject: category, textObject: text, objectImage: imageСheck, longitude: sourcelocationLongitude, latitude: sourcelocationLatitude)
        publishButton.isEnabled = false
    }
    //MARK: - ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.originalImage] as? UIImage else {
            print("No image found")
            imageSelected = false
            return
        }
        selectPhotoButton.layer.cornerRadius = 12
      //  selectPhotoButton.layer.masksToBounds = true
        selectPhotoButton.layer.backgroundColor = UIColor.appColor(.grayPlatinum)?.cgColor
        selectPhotoButton.layer.borderWidth = 2
        selectPhotoButton.layer.borderColor = UIColor.appColor(.grayPlatinum)?.cgColor
        selectPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        getUserLocation()
        imageSelected = true
        formValidation()
        self.dismiss(animated: true, completion: nil)
 
    }
    func getUserLocation(){
        self.userLatitude = self.locationManager.location?.coordinate.latitude
        self.userLongitude = self.locationManager.location?.coordinate.longitude
    }
    @objc func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: - Клавиатура
    fileprivate func  setupNotificationObserver(){
        // следит когда подниметься клавиатура
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // следит когда опускаеться
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
extension AddNewOjectView: AddNewOjectProtocol{
    func failure(error: Error) {
        
    }
    
    func alert(title: String, message: String) {
        
    }
    
    
}
