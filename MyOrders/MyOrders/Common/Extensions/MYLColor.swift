//
//  MYLColor.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-17.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(hex: Int, opacity: CGFloat = 1.0) {
    let red = CGFloat((hex >> 16) & 0xff) / 255
    let green = CGFloat((hex >> 08) & 0xff) / 255
    let blue = CGFloat((hex >> 00) & 0xff) / 255
    self.init(red: red, green: green, blue: blue, alpha: opacity)
  }

  // MARK: - Backgrounds
  
  open class var mainOrangeColor : UIColor {
    return UIColor(hex: 0xF98619)
  }
  
  open class var textPlaceholderColor : UIColor {
    return UIColor(hex: 0x6B7782)
  }
  
  open class var textValueColor : UIColor {
    return UIColor(hex: 0x252525)
  }
  
  open class var textFieldBorderColor : UIColor {
    return UIColor(hex: 0xC4C8CC)
  }
  
  open class var textFieldFocusedBorderColor : UIColor {
    return UIColor(hex: 0xF98619)
  }
  
  open class var textFieldErrorColor : UIColor {
    return UIColor(hex: 0xB91A0E)
  }
  
}
