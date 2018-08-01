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
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
  
  func shadow(radius: CGFloat, strength: CGFloat = 5.0) {
    self.layer.shadowOffset =  CGSize(width: strength, height: strength)
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = 0.65
  }
  
  func addDashedBorder(offset: CGFloat = 0) {
    
    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: offset, y: offset, width: frameSize.width - offset*2, height: frameSize.height - offset*2)
    
    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.lineWidth = 3
    shapeLayer.lineJoin = kCALineJoinRound
    shapeLayer.lineDashPattern = [6, 3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
    
    self.layer.addSublayer(shapeLayer)
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
