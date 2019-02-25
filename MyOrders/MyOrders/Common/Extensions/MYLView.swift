//
//  MYLImageView.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-17.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import SDWebImage

extension UIView {
  
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  func shadow(radius: CGFloat, strength: CGFloat = 6.0) {
    self.layer.shadowOffset =  CGSize(width: strength, height: strength)
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowRadius = radius
    self.layer.cornerRadius = radius
    self.layer.shadowOpacity = 1
    self.layer.masksToBounds = false //this has to be false
  }
  
  func addDashedBorder(offsetX: CGFloat = 0, offsetY: CGFloat = 0) {
    
    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width - 40.0, height: frameSize.height)
    
    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2 + offsetX, y: frameSize.height/2 + offsetY)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.lineWidth = 3
    shapeLayer.lineJoin = kCALineJoinRound
    shapeLayer.lineDashPattern = [6, 3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
    
    self.layer.addSublayer(shapeLayer)
  }
  
  func calculateOffset() -> CGPoint {
    var x: CGFloat = self.frame.origin.x
    var y: CGFloat = self.frame.origin.y
    var superVW = self.superview
    
    while superVW != nil {
      if let contentOffset = (superVW as? UIScrollView)?.contentOffset {
        x -= contentOffset.x
        y -= contentOffset.y
      }
      x += superVW!.frame.origin.x
      y += superVW!.frame.origin.y
      
      superVW = superVW!.superview
    }
    
    return CGPoint(x: x, y: y)
  }
}

extension UIImageView {
  
  func imageFromUrl(_ urlString: String, placeHolder: UIImage? = #imageLiteral(resourceName: "no-image") , completion: ((_ success: Bool) -> Void)? = nil) {
    if let url = URL(string: urlString) {
      self.sd_setImage(with: url, placeholderImage: placeHolder, options: SDWebImageOptions(), completed: { (_, error, _, _) in
        if let block = completion {
          block(error == nil)
        }
      })
    }
  }
  
}
