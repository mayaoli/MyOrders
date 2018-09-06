//
//  EatInViewController.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-23.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class EatInViewController: BaseTextFieldViewController {
  @IBOutlet weak var staffPIN: MYLTextFieldView!
  @IBOutlet weak var customerNumber: MYLTextFieldView!
  @IBOutlet weak var centerView: UIView!
  
  private let thisBill = Bill.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.title = "Eat-In"
    
    centerView.shadow(radius: 10)
    
    var validations = ValidationType.IsRequired.rawValue + ValidationType.IsNumeric.rawValue
    staffPIN.configure(placeholder: nil, validationType: validations, maxLength: 4, alignment: .left, keyboardType: .numberPad)
    staffPIN.delegate = self
    staffPIN.fieldText.returnKeyType = .next
    
    validations = ValidationType.IsRequired.rawValue + ValidationType.IsPositiveNumber.rawValue
    customerNumber.configure(placeholder: nil, validationType: validations, maxLength: 2, alignment: .left, keyboardType: .numberPad)
    customerNumber.delegate = self
    customerNumber.fieldText.returnKeyType = .done
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if thisBill.customers?.count == 0 {
      // only first time will get focus
      staffPIN.fieldText.becomeFirstResponder()
    }
    
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    view.endEditing(true)
    
    switch segue.identifier {
    case ReuseIdentifier.toMenu.rawValue?:
      
      guard let _ = segue.destination as? MenuViewController else {
        break
      }
      
      thisBill.staffPIN = staffPIN.fieldText.text
      if let num: Int = Int(customerNumber.fieldText.text!) {
        thisBill.customers = [Customer](repeating: Customer(), count: num)
      }
      
    default:
      break
    }
  }

  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField.returnKeyType == .next {
      customerNumber.fieldText.becomeFirstResponder()
      return false
    } else if textField.returnKeyType == .done {
      staffPIN.validate()
      customerNumber.validate()
      
      if staffPIN.isValid && customerNumber.isValid {
        self.performSegue(withIdentifier: ReuseIdentifier.toMenu.rawValue, sender: nil)
        return super.textFieldShouldBeginEditing(textField)
      }
      
      return false
    }
    
    return true
  }
}



