//
//  LabelExtension.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import UIKit

extension UILabel{
    class func headerBigText (title: String) -> UILabel{
        let text = UILabel()
        text.text = title
        text.font = UIFont.boldSystemFont(ofSize: 57)
        text.textColor = UIColor.appColor(.grayPlatinum)
        return text
    }
}
