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
extension UITextField{
    class func setupTextField(title: String, hideText: Bool, enabled: Bool) -> UITextField {
        
        let tf = CustomTextField(padding: 16)
        tf.backgroundColor = UIColor(white: 1, alpha: 0.7)
        tf.layer.cornerRadius = 5
        tf.font = UIFont .systemFont(ofSize: 16)
        tf.textColor = .darkText
        tf.isSecureTextEntry = hideText         // скрытие пороля
        tf.isEnabled = enabled
        return tf
    }
}

// функция для кнопки

extension UIButton{
    class func setupButton(title: String, color: UIColor, activation: Bool, invisibility: Bool, laeyerRadius: Double, alpha: Double ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color.withAlphaComponent(alpha)
        button.layer.cornerRadius = laeyerRadius //30/2  // скругляем кнопку
        button.isEnabled = activation   //диактивация кнопки изначально кнопка не активна (активна после заполнения всех полей)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isHidden = invisibility
        
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
    
//
//        button.layer.borderColor = color.cgColor
//        button.backgroundColor = .white
//        button.layer.borderWidth = 3
        
        
        return button
    }
    
    
    
}




// функция для цветов в приложении
extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}



//  структура констрейнов отступов и зависимостей(верх, лево, низ, право, ширина, высота)
struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView{
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?,pading: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
                   anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: pading.top)
               }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: pading.left)
        }
        
        if let bottom = bottom {
                   anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -pading.bottom)
               }
        if let trailing = trailing{
                   anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -pading.right)
               }
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
            
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{
            $0?.isActive = true}
        
        return anchoredConstraints
        
        }
        
    


    func fillSuperview(pading: UIEdgeInsets = .zero)  {
    translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor{
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: pading.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor{
            topAnchor.constraint(equalTo: superviewBottomAnchor, constant: pading.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor{
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: pading.left ).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor{
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: pading.right).isActive = true
        }
    }

    func centerInSuperview(size: CGSize = .zero)  {
    translatesAutoresizingMaskIntoConstraints = false
        if let superviwCenterXAnchor = superview? .centerXAnchor{
            centerXAnchor.constraint(equalTo: superviwCenterXAnchor).isActive = true
        }
        
        if let superviwCenterYAnchor = superview? .centerYAnchor{
            centerYAnchor.constraint(equalTo: superviwCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
}
    
    
}

