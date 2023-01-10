//
//  ExtansionUIview.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 05/01/2023.
//

import Foundation
import UIKit

extension UIView {
  func addShadow() {
    self.layer.shadowColor = UIColor.gray.cgColor
      self.layer.shadowOffset = CGSize(width: 1, height: 1.8)
    self.layer.shadowOpacity = 1
  }
}
