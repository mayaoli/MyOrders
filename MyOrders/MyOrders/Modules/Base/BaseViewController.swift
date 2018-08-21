//
//  BaseViewController.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-23.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit
import TTGSnackbar

// access to view controller from presenter
protocol BaseViewInterface: class {
  var snackbar: TTGSnackbar? { get set }
  
  func animateViewMoving(_ movement:CGFloat)
  func renderError(_ error: NetworkingError)
  func renderWarning(_ message: String)
  func renderMessage(title: String, message: String, completion completionBlock: (() -> Void)?)
}

class BaseViewController: UIViewController, BaseViewInterface {
  
  private var presenter : BasePresenter!
  weak var baseEventHandler: BaseEventsInterface? {
    return presenter
  }
  
  var snackbar: TTGSnackbar?
  var showBackButton: Bool = true {
    didSet {
      self.navigationItem.hidesBackButton = !showBackButton
    }
  }

  // MARK: - following 2 functions could be defined a parent class (ex. baseViewControl)
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    presenter = createPresenter()
    presenter.baseView = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    
    presenter = createPresenter()
    presenter.baseView = self
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func createPresenter() -> BasePresenter {
    //precondition(false, "Prior to use eventHandler, must implement createPresenter func in view controller!")
    
    return BasePresenter()
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
    self.renderBar(error)
  }
  
  func renderWarning(_ message: String) {
    self.renderBar(.customError(message: message), true)
  }
  
  func renderBar(_ error: NetworkingError, _ isWarning: Bool = false) {
    guard self.snackbar == nil else {
      return
    }
    
    DispatchQueue.main.async {
      let noNetworkSnackbar = TTGSnackbar(message: error.debugDescription, duration: .middle)
      //noNetworkSnackbar.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
      noNetworkSnackbar.cornerRadius = 0
      noNetworkSnackbar.backgroundColor = isWarning ? UIColor.yellow : UIColor.red
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
  
  func renderMessage(title: String, message: String, completion completionBlock: (() -> Void)?) {
    var navController: UINavigationController?
    if self.navigationController != nil {
      navController = self.navigationController
    } else {
      navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
    }
    
    guard let topViewController = navController?.viewControllers.first else {
      return
    }
    
    let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
      topViewController.dismiss(animated: true, completion: completionBlock)
    }))
    
    topViewController.present(alertController, animated: true, completion: nil)
  }
}

