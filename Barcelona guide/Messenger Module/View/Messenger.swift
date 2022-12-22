//
//  Messenger.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 14/12/2022.
//

import UIKit


class Messenger: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var presenter: MessengerPresenterProtocol!
    var cellAnother = "CellAnother"
    var cellUser = "CellUser"
    
    var footerMassenger: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.appColor(.grayMidle)
        return view
    }()
    var tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var foonMassegeInput:UIView = {
        var view = UIView()
        view.layer.backgroundColor = UIColor.appColor(.grayPlatinum)?.cgColor
        return view
    }()
   lazy var massegeInput: UITextView = {
       let label = UITextView()
       label.text = "Type your message..."
       label.textAlignment = .left
      
       label.textColor = UIColor.appColor(.grayMidle)
       label.tintColor = UIColor.appColor(.grayMidle)?.withAlphaComponent(0.9)
       label.font = UIFont.systemFont(ofSize: 16)
       label.backgroundColor = UIColor.appColor(.grayPlatinum)
       label.isEditable = true
       
       return label
   }()
    
    
    let openGalery = UIButton.setupButtonImage( color: .clear ,activation: true,invisibility: false, laeyerRadius: 12, alpha: 0,resourseNa: "camera")
    
    let sendButton = UIButton.setupButton(title: "SEND", color: .clear, activation: true, invisibility: false, laeyerRadius: 12, alpha: 0, textcolor: UIColor.appColor(.grayPlatinum)!)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.grayMidle)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapDismiss), name: UIApplication.willResignActiveNotification, object:nil)
        navigationController?.navigationBar.tintColor = UIColor.appColor(.grayPlatinum)
        
        massegeInput.delegate = self
        configTable()
        configView()
        setupTapGesture()
        openGalery.addTarget(self, action: #selector(openPicker), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendMassege), for: .touchUpInside)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
      
        //  let safeArea = self.tableView.safeAreaInsets
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapDismiss), name: UIApplication.willResignActiveNotification, object:nil)
        AppUtility.lockOrientation(.portrait)
        //переворот таблицы
        tableView.transform = CGAffineTransformMakeScale(1, -1)
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func configTable(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.backgroundColor = UIColor.appColor(.bluePewter)
        self.tableView.register(MassegeCell.self, forCellReuseIdentifier: cellAnother)
        self.tableView.register(UserMassegeCell.self, forCellReuseIdentifier: cellUser)
        self.tableView.separatorColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.4
   
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // guard let cell = cell as? MassegeCell else { return }
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellAnother, for: indexPath) as! MassegeCell
            cell.tintColor = UIColor.appColor(.pinkLightSalmon)
            cell.labelMasseg.text = "Hi, how are you doing? I saw you giving away a motorcycle helmet.I'd like to take it away.When can I do this?"
            cell.selectionStyle = .none
            cell.transform = CGAffineTransformMakeScale(1, -1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellUser, for: indexPath) as! UserMassegeCell
            cell.tintColor = UIColor.appColor(.pinkLightSalmon)
            cell.labelMasseg.text = "Hi, yes, of course you can come by tonight.I live in the Plaza de Espana."
            cell.selectionStyle = .none
            cell.transform = CGAffineTransformMakeScale(1, -1)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        print(indexPath)
        
        //   // прижать вниз
        //   self.tableView.layoutIfNeeded()
        //   self.tableView.setContentOffset(CGPoint(x: 0, y: //tableView.contentSize.height-tableView.frame.height+tableView.contentInset.bottom), animated: true)
    }
    // MARK: for Header and footer
    // for header
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 10))
        footerView.backgroundColor = UIColor.appColor(.bluePewter)
        let footerTitle = UILabel(frame: CGRect(x: 10, y: 10, width: self.tableView.frame.size.width, height: 20))
        footerTitle.text = "The chat started on December 27"
        footerTitle.textAlignment = .center
        footerTitle.textColor = UIColor.appColor(.grayPlatinum)?.withAlphaComponent(0.6)
        footerView.transform = CGAffineTransformMakeScale(1, -1)
        footerView.addSubview(footerTitle)
        
        
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 0))
        headerView.backgroundColor = UIColor.appColor(.pinkLightSalmon)
        headerView.transform = CGAffineTransformMakeScale(1, -1)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.massegeInput = UITextView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height:60))
        headerView.addSubview(self.massegeInput)
     
        NSLayoutConstraint.activate([
            massegeInput.trailingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.trailingAnchor),
            massegeInput.leadingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leadingAnchor),
            massegeInput.topAnchor.constraint(equalTo: headerView.topAnchor),
            massegeInput.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0)
        ])
       // textViewDidChange(self.massegeInput )
       
     //   headerView.addSubview(massegeInput)
      //  massegeInput =  UITextView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 60))
     //   massegeInput.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: //headerView.bottomAnchor, trailing: headerView.trailingAnchor, pading: .init(top: 20, left: 10, bottom: //10, right: 20),size: .init(width: 0, height: 60))
       // massegeInput.layer.cornerRadius = 12
      //  massegeInput.layer.backgroundColor = UIColor.appColor(.grayPlatinum)?.cgColor
      //  massegeInput.layer.zPosition = 1
       
  
  
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func updateContentInsetForTableView( tableView:UITableView,animated:Bool) {
        
        let lastRow = tableView.numberOfRows(inSection: 0)
        let lastIndex = lastRow > 0 ? lastRow - 1 : 0;
        
        let lastIndexPath = IndexPath(row: lastIndex, section: 9)
        
        
        let lastCellFrame = tableView.rectForRow(at: lastIndexPath)
        let topInset = max(tableView.frame.height - lastCellFrame.origin.y - lastCellFrame.height, 0)
        
        var contentInset = tableView.contentInset;
        contentInset.top = topInset;
        
        _ = UIView.AnimationOptions.beginFromCurrentState;
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            
            tableView.contentInset = contentInset;
        })
        
    }
    
    @objc fileprivate func formValidation(){
        
    }
    @objc fileprivate func openPicker() {
        print("openPicker"
        )}
    @objc fileprivate func sendMassege() {
        print("sendMassege")
        guard  var frame = self.tableView.tableHeaderView?.frame else {return}
        frame.size.height += 90
        
    }
    
    func configView(){
        view.addSubview(footerMassenger)
        footerMassenger.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: view.frame.width, height: 80))
        // footerMassenger.layer.cornerRadius = 12
        footerMassenger.layer.backgroundColor = UIColor.appColor(.grayMidle)?.cgColor
        
 /*       view.addSubview(foonMassegeInput)
        foonMassegeInput.anchor(top: nil, leading: view.leadingAnchor, bottom: footerMassenger.topAnchor, trailing: view.trailingAnchor, pading: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: view.frame.width, height:0))
      //  foonMassegeInput.layer.zPosition = 0
        foonMassegeInput.backgroundColor = .red
       view.addSubview(massegeInput)
       massegeInput.anchor(top: foonMassegeInput.topAnchor, leading: foonMassegeInput.leadingAnchor, bottom: footerMassenger.topAnchor, trailing: foonMassegeInput.trailingAnchor, pading: .init(top: 10, left: 20, bottom: 0, right: 20),size: .init(width: 0, height: 60))
       massegeInput.layer.cornerRadius = 12
       massegeInput.layer.backgroundColor = UIColor.appColor(.grayPlatinum)?.cgColor
       massegeInput.layer.zPosition = 1
       
    */
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:  footerMassenger.topAnchor, trailing: view.trailingAnchor,  pading: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height:0))
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.layoutIfNeeded()
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentSize.height-tableView.frame.height+tableView.contentInset.bottom), animated: true)
       // foonMassegeInput.layer.zPosition = 1
        
        view.addSubview(openGalery)
        openGalery.anchor(top: footerMassenger.topAnchor, leading: footerMassenger.leadingAnchor, bottom: nil, trailing: nil, pading: .init(top: 18, left: 20, bottom: 0, right: 0),size: .init(width: 20, height: 20))
        
        
        view.addSubview(sendButton)
        sendButton.anchor(top: footerMassenger.topAnchor, leading: nil, bottom: nil, trailing: footerMassenger.trailingAnchor, pading: .init(top: 18, left: 0, bottom: 0, right: 20),size: .init(width: 50, height: 25))
        
    }
    // MARK: - Keyboard
    fileprivate func  setupNotificationObserver(){
        // следит когда подниметься клавиатура
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // следит когда пbcxtpftn
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardSwowHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        let bottomSpace =  self.tableView.frame.origin.y //+ massegeInput.frame.height       //на сколько должна сдвинуть интерфейс
        let difference = keyboardframe.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(-difference - massegeInput.frame.height))
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
extension Messenger : UITextViewDelegate {
    func adjustUITextViewHeight(arg : UITextView) {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        //   print(massegeInput.sizeThatFits) //the textView parameter is the textView where text was changed
        //massegeInput.isHidden = !textView.text.isEmpty
        var oldValueHeigt = 0.0
        let sizeThatFitsTextView = massegeInput.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(MAXFLOAT)))
        let heightOfText = sizeThatFitsTextView.height
        guard oldValueHeigt != heightOfText else {return}
        print(heightOfText)
        if oldValueHeigt > heightOfText{
            
            
        }
        if oldValueHeigt < heightOfText{
            adjustUITextViewHeight(arg: self.massegeInput)
           // guard var frame = self.tableView.tableHeaderView!.frame else { return}
           // frame.size.height = heightOfText
                //tableView.headerView(forSection: 1)?.transform = CGAffineTransformMakeScale(0, 1)
          
           
           // self.massegeInput.transform = CGAffineTransform(translationX: 1, y: CGFloat(-30))
            
           // var frame = self.tableView.tableHeaderView?.frame
          
        //    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: //.curveEaseOut, animations: {
        //        self.tableView.tableHeaderView?.transform = CGAffineTransform(translationX: 0, y: CGFloat( //(frame?.height ?? 0) + 20)) // интерфейс опускаеться в низ
        //    }, completion: nil)
          //  self.massegeInput.transform = CGAffineTransform(translationX: 1, y: CGFloat(-50))
       //     var frame = self.tableView.tableHeaderView!.frame
         //      frame.size.height = heightOfText
           // self.tableView.tableHeaderView!.frame = frame
         //   self.tableView.tableHeaderView!.transform = CGAffineTransform(translationX: 0, y: CGFloat( frame.height + 20))
          //  self.foonMassegeInput.transform = CGAffineTransform(translationX: 0, y: CGFloat(-40))
          //  self.massegeInput.transform = CGAffineTransform(translationX: 0, y: CGFloat(-40))
           // tableView.transform = CGAffineTransformMakeScale(1, -1)
            //tableView.setContentOffset(.zero, animated: true)
     //   foonMassegeInput.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -40)
        }
        if oldValueHeigt == 0{}
        oldValueHeigt = heightOfText
        // let difference = keyboardframe.height - bottomSpace
        //  self.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(-difference - 15))
        
    }
    
}
extension Messenger: MessengerProtocol{
    func failure(error: Error) {
        print("Messenger failure")
    }
    
    func alert(title: String, message: String) {
        print("Messenger alert")
    }
   
}
