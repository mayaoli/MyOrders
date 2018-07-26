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
  
  func animateViewMoving(_ movement:CGFloat)
  func renderError(_ error: NetworkingError)
  func renderMessage(title: String, message: String)
}

class BaseViewController: UIViewController, BaseViewInterface {
  
  private var presenter : BasePresenter!
  weak var eventHandler: BaseEventsInterface? {
    return presenter
  }
  
  var snackbar: TTGSnackbar?
  var activeField: UITextField?

  // MARK: - following 2 functions could be defined a parent class (ex. baseViewControl)
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    (self.eventHandler as? BasePresenter)?.view = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    
    presenter = BasePresenter()
    presenter.view = self
  }
  
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
  
  func animateViewMoving(_ movement :CGFloat) {
    let movementDuration:TimeInterval = 0.3
    UIView.beginAnimations("animateView", context: nil)
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
    print("@@@textFieldShouldBeginEditing")
    activeField = textField
    
    self.eventHandler?.calculateOffset(textField)
    textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: UIControlEvents.editingChanged)
    if let pvw = (textField as? MYLTextField)?.parentView as? MYLTextFieldView {
      pvw.beginEditing()
    }
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    print("@@@textFieldDidEndEditing")
    textField.removeTarget(self, action: nil, for: UIControlEvents.editingChanged)
    if let pvw = (textField as? MYLTextField)?.parentView as? MYLTextFieldView {
      pvw.endEditing()
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    activeField = nil
    return true
  }
  
  @objc func textFieldValueChanged(_ textField: UITextField) {
    if let pvw = (activeField as? MYLTextField)?.parentView as? MYLTextFieldView {
      pvw.valueChanged()
    }
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, activeField != nil else {
      return
    }
    
    self.eventHandler?.shouldScroll(keyboardSize.height, self.view.frame.size.height)
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    self.eventHandler?.shouldScroll(0, self.view.frame.size.height)
  }
}
