//
//  Utils.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 27/12/2021.
//

import UIKit

class CustomTextField: UITextField{
    let padding: CGFloat
    init(padding:CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override var intrinsicContentSize: CGSize{
        return .init(width: 0, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// функция для лейбл

extension UILabel{
    class func setupLabel(title: String) -> UILabel {
        
        let text = UILabel()
        text.text = title
        text.font = UIFont.systemFont(ofSize: 16)
        
        return text
    }
}

// функция для поля текст филд

extension UILabel{
    class func setupLabel(title: String, alignment: NSTextAlignment, color: UIColor, alpha: Double, size: Int, numberLines: Int ) -> UILabel{
        let label = UILabel()
        label.text = title
        label.textAlignment = alignment
        label.textColor = color.withAlphaComponent(alpha)
        label.font = UIFont.boldSystemFont(ofSize: CGFloat(size))
        label.numberOfLines = numberLines
        return label
    }
}

// функция для кнопки

extension UIButton{
    class func setupButton(title: String, color: UIColor, activation: Bool, invisibility: Bool, laeyerRadius: Double, alpha: Double, textcolor: UIColor  ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textcolor, for: .normal)
        button.backgroundColor = color.withAlphaComponent(alpha)
        button.layer.cornerRadius = laeyerRadius //30/2  // скругляем кнопку
        button.isEnabled = activation   //диактивация кнопки изначально кнопка не активна (активна после заполнения всех полей)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isHidden = invisibility
        button.imageView?.contentMode =  .scaleAspectFit
       
        return button
    }
    class func setupButtonImage(color: UIColor, activation: Bool, invisibility: Bool, laeyerRadius: Double, alpha: Double, resourseNa: String ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color.withAlphaComponent(alpha)
        button.layer.cornerRadius = laeyerRadius //30/2  // скругляем кнопку
        button.isEnabled = activation   //диактивация кнопки изначально кнопка не активна (активна после заполнения всех полей)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isHidden = invisibility
        button.setImage(#imageLiteral(resourceName: resourseNa), for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 1)
        button.imageView?.contentMode =  .scaleAspectFit
        return button
    }
}











