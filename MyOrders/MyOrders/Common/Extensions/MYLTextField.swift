//
//  MYLTextField.swift
//  MyOrders
//
//  Created by RBC on 2018-07-23.
//  Copyright © 2018 RBC. All rights reserved.
//

import UIKit

class MYLTextField: UITextField {
  
  var fieldValidationType: UInt = 0
  var parentView: UIView? = nil
  
  func validate() -> String? {
    guard self.text != nil, fieldValidationType > 0 else {
      return nil
    }
    
    let trimedVal: String = self.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    var curValidation: ValidationType = .IsRequired
    
    while curValidation.rawValue <= fieldValidationType, curValidation.rawValue <= ValidationType.IsPostcode.rawValue {
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
      
      curValidation = ValidationType.init(rawValue: curValidation.rawValue * 2)!
    }
    
    return nil
  }
  
}
