//
//  AddNewOjectView.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 12/12/2022.
//

import UIKit
import CoreLocation


class AddNewOjectView:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UITextFieldDelegate {

    var presenter: AddNewOjectPresenterProtocol!
    var locationManager = CLLocationManager()
    var userLongitude: CLLocationDegrees!
    var userLatitude: CLLocationDegrees!
    var myPicker: UIPickerView! = UIPickerView()
    
    var selectedValue: String?{
        didSet {
         print("selectedValue chenging!")
           // guard selectedValue != nil else{return}
            formValidation()
        }
    }
    var uidSelectedValue: String?{
        didSet {
         print("uidSelectedValue chenging!")
           // guard selectedValue != nil else{return}
            formValidation()
        }
    }

    var imageSelected = false
    var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "foto"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true
        button.tintColor = UIColor(white: 1, alpha: 0.5)
        return button
    }()
    fileprivate var categoryObject = UITextField.setupTextField(title: "Сhoose category..", hideText: false, enabled: true)
    fileprivate let nameObject = UITextField.setupTextField(title: "Item name...", hideText: false, enabled: true)
    fileprivate let textObject = UITextField.setupTextField(title: "Сommentary..", hideText: false, enabled: true)
    fileprivate let publishButton =    UIButton.setupButton(title: "Рublish", color: UIColor.appColor(.pinkLightSalmon)!, activation: false, invisibility: false, laeyerRadius: 12, alpha: 0.7, textcolor: UIColor.appColor(.grayPlatinum)!)
    lazy var stackView = UIStackView(arrangedSubviews: [categoryObject,nameObject,textObject])

    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.bluePewter)
        navigationController?.navigationBar.tintColor = UIColor.appColor(.grayPlatinum)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
       // self.navigationItem.rightBarButtonItem?.tintColor = UIColor.appColor(.grayPlatinum)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
   
       
        
        self.categoryObject.inputView = UIView()
        self.categoryObject.inputAccessoryView = UIView()
     
      
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
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading:  nil, bottom: nil, trailing:  nil, pading: .init(top: view.frame.height/10, left: 0, bottom: view.frame.height/8, right: 0), size: .init(width: stackView.frame.width/4, height: stackView.frame.width/4))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
        selectPhotoButton.layer.cornerRadius = 12
    
  
  
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
            imageSelected == true,
            categoryObject.hasText,
            nameObject.hasText,
            textObject.hasText,
            self.selectedValue != nil,
            self.uidSelectedValue != nil
        else {
            publishButton.isEnabled = false
            publishButton.backgroundColor = UIColor.appColor(.redLightSalmon)!.withAlphaComponent(0.7)
            return
            }
        publishButton.isEnabled = true
        publishButton.backgroundColor = UIColor.appColor(.redDarkSalmon)
        }
 
    //MARK: - Add
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
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading:  view.safeAreaLayoutGuide.leadingAnchor, bottom: stackView.topAnchor, trailing:  view.safeAreaLayoutGuide.trailingAnchor, pading: .init(top: 0, left: 20, bottom: 40, right: 20), size: .init(width: stackView.frame.width, height: stackView.frame.width))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //выстовляет по середине экрана
        selectPhotoButton.layer.cornerRadius = 12
       //selectPhotoButton.layer.masksToBounds = true
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
        guard  value.cgRectValue.height != 0  else {return}
        
        let keyboardframe = value.cgRectValue    //рамка клавиатуры
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height        //на сколько должна сдвинуть интерфейс
        let difference = keyboardframe.height - bottomSpace
        if difference > 50 {
         self.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(-difference) - 19)
         }
        if difference < 50 && difference != 0  {
            self.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(-keyboardframe.height + (bottomSpace/2)) )
         }
       
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
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity     // интерфейс опускаеться в низ
        }, completion: nil)
        view.endEditing(true)
    }
   
   
}
extension AddNewOjectView:UIPickerViewDataSource, UIPickerViewDelegate{
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.category?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = presenter.category?[row].nameCategory ?? ""
        uidSelectedValue = presenter.category?[row].uidCategory ?? ""
        categoryObject.text = presenter.category?[row].nameCategory ?? ""
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.category?[row].nameCategory ?? ""
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: presenter.category?[row].nameCategory ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.grayMidle)!])
    }
    
}
extension AddNewOjectView: AddNewOjectProtocol{
    func failure(error: Error) {
        
    }
    
    func alert(title: String, message: String) {
        
    }
    func reload() {
        myPicker = UIPickerView()
        myPicker.dataSource = self
        myPicker.delegate = self
        categoryObject.delegate = self
        categoryObject.inputView = myPicker
     //   categoryObject.text = String(presenter.category?[0].nameCategory ?? "")
    //    self.selectedValue = presenter.category?[0].nameCategory ?? ""
      //  self.uidSelectedValue = presenter.category?[0].uidCategory ?? ""
        myPicker.backgroundColor = UIColor.appColor(.grayPlatinum)
       // myPicker.tintColor = UIColor.appColor(.grayMidle)
       
        self.myPicker.reloadAllComponents()
    }
    
    
}
