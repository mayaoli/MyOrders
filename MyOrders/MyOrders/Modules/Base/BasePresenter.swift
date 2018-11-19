//
//  BasePresenter.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-24.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit

// access to presenter from view controller
protocol BaseEventsInterface: class {
  func calculateOffset(_ control: UIControl?)
  func shouldScroll(_ keyboardHeight: CGFloat, _ viewHeight: CGFloat) -> Void
}

// access to presenter from interactor
protocol BaseOutputInterface: class {
  
}

class BasePresenter: NSObject, BaseEventsInterface, BaseOutputInterface {
  
  var baseInteractor: BaseInteractor!
  weak var baseView: BaseViewInterface?
  
  private var containerOffset: CGPoint!
  private var lastOffsetY: CGFloat! = 0
  private let additionalOffset:CGFloat = 60.0
  
  override init() {
    super.init()
    baseInteractor = self.createInteractor()
    baseInteractor.baseOutput = self
  }
  
  func createInteractor() -> BaseInteractor {
    return BaseInteractor()
  }
  
  func calculateOffset(_ control: UIControl?) {
    guard control != nil else {
      return
    }
    
    var x: CGFloat = control!.frame.origin.x
    var y: CGFloat = control!.frame.origin.y + control!.frame.size.height - lastOffsetY
    var superVW = control!.superview
    
    while superVW != nil {   //superVW != self.view
      x += superVW!.frame.origin.x
      y += superVW!.frame.origin.y
      
      superVW = superVW!.superview
    }
    
    containerOffset = CGPoint(x: x, y: y)
    print("### containerOffset = (\(x), \(y))")
  }
  
  func shouldScroll(_ keyboardHeight: CGFloat, _ viewHeight: CGFloat) {
    
    guard containerOffset != nil else {
      return
    }
    
    print("### lastOffsetY = \(lastOffsetY ?? 0)")
    
    // move if keyboard hide input field
    let collapseSpace = keyboardHeight - viewHeight + containerOffset.y + additionalOffset
    
    print("### collapseSpace = \(collapseSpace)")
    if collapseSpace < 0 {
      // no collapse
      if lastOffsetY > 0 {
        self.baseView!.animateViewMoving(lastOffsetY)
        lastOffsetY = 0
      }
      return
    }
    
    // set new offset for scroll view
    if lastOffsetY != collapseSpace {
      lastOffsetY = lastOffsetY + collapseSpace
      self.baseView!.animateViewMoving(-lastOffsetY)
    }
  }
  
}
