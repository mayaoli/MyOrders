//
//  EatInViewController.swift
//  MyOrders
//
//  Created by RBC on 2018-07-23.
//  Copyright © 2018 RBC. All rights reserved.
//

import UIKit

class EatInViewController: BaseViewController {
  @IBOutlet weak var staffPIN: MYLTextFieldView!
  @IBOutlet weak var customerNumber: MYLTextFieldView!
  @IBOutlet weak var centerView: UIView!
  
  var thisBill: Bill!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    centerView.layer.shadowOffset =  CGSize(width: 5, height: 5)
    centerView.layer.shadowColor = UIColor.black.cgColor
    centerView.layer.shadowRadius = 10
    centerView.layer.shadowOpacity = 0.65
    
    let validations = ValidationType.IsRequired.rawValue + ValidationType.IsNumeric.rawValue
    staffPIN.configure(placeholder: nil, validationType: validations, maxLength: 4, alignment: .left, keyboardType: .numberPad)
    staffPIN.delegate = self
    staffPIN.fieldText.returnKeyType = .next
    
    customerNumber.configure(placeholder: nil, validationType: validations, maxLength: 2, alignment: .left, keyboardType: .numberPad)
    customerNumber.delegate = self
    customerNumber.fieldText.returnKeyType = .done
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField.returnKeyType == .next {
      customerNumber.fieldText.becomeFirstResponder()
      return false
    } else if textField.returnKeyType == .done {
      staffPIN.validate()
      customerNumber.validate()
      if staffPIN.isValid && customerNumber.isValid {
        
        thisBill.staffPIN = staffPIN.fieldText.text
        return super.textFieldShouldBeginEditing(textField)
      }
      
      return false
    }
    
    return true
  }
}



