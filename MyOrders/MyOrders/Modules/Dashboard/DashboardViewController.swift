//
//  DashboardViewController.swift
//  MyOrders
//
//  Created by RBC on 2018-07-16.
//  Copyright © 2018 RBC. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController, UITextFieldDelegate {

  @IBOutlet weak var ScrollView: UIScrollView!
  @IBOutlet weak var ButtonContainer: UIView!
  @IBOutlet weak var EatInButton: UIButton!
  @IBOutlet weak var TakeOutButton: UIButton!
  @IBOutlet weak var DeliveryButton: UIButton!
  @IBOutlet weak var TableNumberInputView: UIView!
  @IBOutlet weak var TableNumber: MYLTextFieldView!
  @IBOutlet weak var testField: UITextField!
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //ScrollView.contentOffset = CGPoint(x: 0.0, y: -200.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  // MARK: - Actions
  @IBAction func btnEatInTapped(_ sender: Any) {
    let eps: CGFloat = 1e-5
    let frm = EatInButton.frame

    TableNumberInputView.isHidden = false
    TableNumberInputView.frame = CGRect(x: frm.origin.x + frm.width/2, y: frm.origin.y - 80, width: DeliveryButton.frame.minX - frm.origin.x, height: TableNumberInputView.frame.height)
    TableNumberInputView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    TableNumberInputView.transform = CGAffineTransform(scaleX: eps, y: eps)

    TableNumberInputView.layer.shadowOffset =  CGSize(width: 5, height: 5)
    TableNumberInputView.layer.shadowColor = UIColor.black.cgColor
    TableNumberInputView.layer.shadowRadius = 10
    TableNumberInputView.layer.shadowOpacity = 0.65

    TableNumber.configure(placeholder: nil, validationType: ValidationType.IsRequired.rawValue, maxLength: 2, alignment: .center, keyboardType: .numberPad)
    TableNumber.delegate = self
    //testField.delegate = self
    
    UIView.animate(withDuration: 1.0,
                   delay: 0.0,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 0.5,
                   options: UIViewAnimationOptions(),
                   animations: {

      self.TableNumberInputView.transform = CGAffineTransform(translationX: -self.TableNumberInputView.bounds.width/2, y: 0)

    }) { _ in

    }

  }
  
  @IBAction func btnTakeOutTapped(_ sender: Any) {
  }
  
  @IBAction func btnDeliveryTapped(_ sender: Any) {
  }
  
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    animateViewMoving(up: true, moveValue: 200)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    animateViewMoving(up: false, moveValue: 200)
  }
  
  func animateViewMoving (up:Bool, moveValue :CGFloat){
    let movementDuration:TimeInterval = 0.3
    let movement:CGFloat = ( up ? -moveValue : moveValue)
    UIView.beginAnimations( "animateView", context: nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(movementDuration )
    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    UIView.commitAnimations()
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if keyboardHeight != nil {
      return
    }
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      keyboardHeight = keyboardSize.height
      // so increase contentView's height by keyboard height
      UIView.animate(withDuration: 0.3, animations: {
        self.constraintContentHeight.constant += self.keyboardHeight
      })
      // move if keyboard hide input field
      let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
      let collapseSpace = keyboardHeight - distanceToBottom
      if collapseSpace < 0 {
        // no collapse
        return
      }
      // set new offset for scroll view
      UIView.animate(withDuration: 0.3, animations: {
        // scroll to the position above keyboard 10 points
        self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
      })
    }
  }
}
