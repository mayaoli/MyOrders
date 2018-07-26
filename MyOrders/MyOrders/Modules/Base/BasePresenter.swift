//
//  BasePresenter.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-24.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit

protocol BaseEventsInterface: class {
  var view: BaseViewInterface? { get }
  
  func calculateOffset(_ control: UIControl?)
  func shouldScroll(_ keyboardHeight: CGFloat, _ viewHeight: CGFloat) -> Void
}

class BasePresenter: NSObject, BaseEventsInterface {

  weak var view: BaseViewInterface?
  private var containerOffset: CGPoint!
  private var lastOffsetY: CGFloat! = 0
  
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
    
    print("### lastOffsetY = \(lastOffsetY)")
    
    // move if keyboard hide input field
    let collapseSpace = keyboardHeight - viewHeight + containerOffset.y
    
    print("### collapseSpace = \(collapseSpace)")
    if collapseSpace < 0 {
      // no collapse
      if lastOffsetY > 0 {
        self.view!.animateViewMoving(lastOffsetY)
        lastOffsetY = 0
      }
      return
    }
    
    // set new offset for scroll view
    if lastOffsetY != collapseSpace + 45 {
      lastOffsetY = collapseSpace + 45
      self.view!.animateViewMoving(-lastOffsetY)
    }
  }
  
}
