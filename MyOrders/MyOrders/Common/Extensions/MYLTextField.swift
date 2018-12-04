//
//  MYLTextField.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-23.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class MYLTextField: UITextField {
  
  var fieldValidationType: UInt = 0
  weak var parentView: UIView? = nil
  
  func validate() -> String? {
    guard self.text != nil, fieldValidationType > 0 else {
      return nil
    }
    
    let trimedVal: String = self.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    var curValidation: ValidationType = .IsRequired
    
    while curValidation.rawValue <= fieldValidationType {
      if (fieldValidationType & curValidation.rawValue) == curValidation.rawValue {
        
        if curValidation == .IsRequired {
          if trimedVal.isEmpty {
            return curValidation.error
          }
        } else if trimedVal.isEmpty {
          return nil
        }
        
        do {
          let regex = try NSRegularExpression(pattern: curValidation.regex)
          let results = regex.matches(in: trimedVal, range: NSRange(trimedVal.startIndex..., in: trimedVal))
          
          if results.count == 0 {
            return curValidation.error
          }
          
        } catch {
          print("invalid regex: \(error.localizedDescription)")
        }
      }
      
      if curValidation.rawValue < ValidationType.LastType.rawValue {
        curValidation = ValidationType.init(rawValue: curValidation.rawValue * 2)!
      } else {
        break
      }
    }
    
    return nil
  }
  
}
