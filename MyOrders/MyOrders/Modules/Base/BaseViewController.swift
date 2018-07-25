//
//  BaseViewController.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-23.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit
import TTGSnackbar

protocol BaseViewInterface: class {

  var snackbar: TTGSnackbar? { get set }
  
  func renderError(_ error: NetworkingError)
  func renderMessage(title: String, message: String)
}

class BaseViewController: UIViewController, BaseViewInterface {
  
  var snackbar: TTGSnackbar?
  var activeField: UITextField!
  var lastOffsetY: CGFloat! = 0
  var keyboardHeight: CGFloat! = 0
  var containerOffset: CGPoint!

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    super.viewWillDisappear(animated)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
  
  func renderError(_ error: NetworkingError) {
    guard self.snackbar == nil else {
      return
    }
    
    DispatchQueue.main.async {
      let noNetworkSnackbar = TTGSnackbar(message: error.debugDescription, duration: .middle)
      //noNetworkSnackbar.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
      noNetworkSnackbar.cornerRadius = 0
      noNetworkSnackbar.backgroundColor = UIColor.red
      noNetworkSnackbar.messageTextAlign = .center
      noNetworkSnackbar.show()
      noNetworkSnackbar.onSwipeBlock = { (snackbar, direction) in
        switch direction {
        case .right:
          snackbar.animationType = .slideFromLeftToRight
        default:
          snackbar.animationType = .slideFromRightToLeft
        }
        snackbar.dismiss()
      }
      noNetworkSnackbar.dismissBlock = { [weak self] _ in
        guard let strongSelf = self else {
          return
        }
        strongSelf.snackbar = nil
      }
      self.snackbar = noNetworkSnackbar
    }
  }
  
  func renderMessage(title: String, message: String) {
    guard let navController = self.navigationController, let topViewController = navController.viewControllers.first else {
      return
    }
    let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
      topViewController.dismiss(animated: true, completion: nil)
    }))
    
    topViewController.present(alertController, animated: true, completion: nil)
  }
}


// MARK: UITextFieldDelegate
extension BaseViewController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    activeField = textField
    
    var x: CGFloat = activeField.frame.origin.x
    var y: CGFloat = activeField.frame.origin.y - self.lastOffsetY
    var superVW = activeField.superview
    
    while superVW != nil, superVW != self.view {
      x += superVW!.frame.origin.x
      y += superVW!.frame.origin.y
      
      superVW = superVW!.superview
    }
    
    self.containerOffset = CGPoint(x: x, y: y)
    print("### containerOffset = (\(x), \(y))")
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    activeField?.resignFirstResponder()
    activeField = nil
    return true
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    guard activeField != nil else {  // keyboardHeight == nil,
      return
    }
    
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      keyboardHeight = keyboardSize.height
      
      print("### keyboardHeight = \(keyboardHeight)")
      
      // so increase contentView's height by keyboard height
      //self.ContentHeightConstraint.constant += self.keyboardHeight
      
      // move if keyboard hide input field
      let distanceToBottom = self.view.frame.size.height - (containerOffset.y + activeField!.frame.origin.y + activeField!.frame.size.height)
      let collapseSpace = keyboardHeight - distanceToBottom
      
      print("### collapseSpace = \(collapseSpace)")
      if collapseSpace < 0 {
        // no collapse
        if self.lastOffsetY > 0 {
          animateViewMoving(up: false, moveValue: self.lastOffsetY)
          self.lastOffsetY = 0
        }
        return
      }
      
      // set new offset for scroll view
      if self.lastOffsetY != collapseSpace + 45 {
        self.lastOffsetY = collapseSpace + 45
        animateViewMoving(up: true, moveValue: self.lastOffsetY)
      }
      
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    
    animateViewMoving(up: false, moveValue: self.lastOffsetY)
    self.lastOffsetY = 0
    
    //    UIView.animate(withDuration: 0.3) {
    //      self.ContentHeightConstraint.constant -= self.keyboardHeight
    //
    //      self.ScrollView.contentOffset = self.lastOffset
    //    }
    
    keyboardHeight = nil
  }
}
