//
//  DashboardViewController.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-16.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class DashboardViewController: BaseTextFieldViewController {

  @IBOutlet weak var ScrollView: UIScrollView!
  @IBOutlet weak var ButtonContainer: UIView!
  @IBOutlet weak var EatInButton: UIButton!
  @IBOutlet weak var TakeOutButton: UIButton!
  @IBOutlet weak var DeliveryButton: UIButton!
  @IBOutlet weak var TableNumberInputView: UIView!
  @IBOutlet weak var TableNumber: MYLTextFieldView!
  
  private var gestureRecognizer:UITapGestureRecognizer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Dashboard"
    
    gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(tappedAnywhere(_:)))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    
  }
  
//  override func createPresenter() -> BasePresenter {
//    return DashboardPresenter()
//  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case ReuseIdentifier.toEatIn.rawValue?:
      let bill = Bill()
      
      guard let destVC = segue.destination as? EatInViewController, TableNumber.isValid else {
          break
      }
      bill.tableNumber = TableNumber.fieldText.text
      destVC.thisBill = bill
      
    default:
      break
    }
  }
  
  // MARK: UITextFieldDelegate
  override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    return super.textFieldShouldBeginEditing(textField)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    TableNumber.validate()
    
    if TableNumber.isValid  {
      textField.resignFirstResponder()
      TableNumberInputView.isHidden = true
      self.performSegue(withIdentifier: ReuseIdentifier.toEatIn.rawValue, sender: nil)
      return true
    } else {
      return false
    }
  }

  
  // MARK: - Actions
  @IBAction func btnEatInTapped(_ sender: Any) {
    let eps: CGFloat = 1e-5
    
    view.addGestureRecognizer(gestureRecognizer)
    TableNumberInputView.isHidden = false
    TableNumberInputView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    TableNumberInputView.transform = CGAffineTransform(scaleX: eps, y: eps)
    TableNumberInputView.updateConstraints()
    
    TableNumberInputView.shadow(radius: 10)

    let validations = ValidationType.IsRequired.rawValue + ValidationType.IsNumeric.rawValue
    TableNumber.configure(placeholder: nil, validationType: validations, maxLength: 2, alignment: .center, keyboardType: .numberPad)
    TableNumber.delegate = self
    
    
    UIView.animate(withDuration: 1.0,
                   delay: 0.0,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 0.5,
                   options: UIViewAnimationOptions(),
                   animations: {
      self.TableNumberInputView.transform = CGAffineTransform(translationX: -self.TableNumberInputView.bounds.width/2, y: 0)
    }) { _ in
      self.TableNumber.fieldText.becomeFirstResponder()
    }

  }
  
  @IBAction func btnTakeOutTapped(_ sender: Any) {
  }
  
  @IBAction func btnDeliveryTapped(_ sender: Any) {
  }
  
}

// MARK: UIGestureRecognizerDelegate
extension DashboardViewController: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.ButtonContainer)
  }
  
  @objc private func tappedAnywhere(_ tap: UITapGestureRecognizer) {
    if tap.state == .ended {
      view.endEditing(true)
      TableNumberInputView.isHidden = true
      view.removeGestureRecognizer(gestureRecognizer)
    }
  }
}
