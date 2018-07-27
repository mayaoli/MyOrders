//
//  BaseViewController.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-23.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit
import TTGSnackbar


class BaseTextFieldViewController: BaseViewController, UITextFieldDelegate {
  
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
 

  // MARK: UITextFieldDelegate
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    self.eventHandler?.calculateOffset(textField)
    if let pvw = (textField as? MYLTextField)?.parentView as? MYLTextFieldView {
      pvw.beginEditing()
    }
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let pvw = (textField as? MYLTextField)?.parentView as? MYLTextFieldView {
      pvw.endEditing()
    }
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
      return
    }
    
    self.eventHandler?.shouldScroll(keyboardSize.height, self.view.frame.size.height)
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    self.eventHandler?.shouldScroll(0, self.view.frame.size.height)
  }
}
