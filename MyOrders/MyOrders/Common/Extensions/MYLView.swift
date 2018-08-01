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
  
  func shadow(radius: CGFloat) {
    self.layer.shadowOffset =  CGSize(width: 5, height: 5)
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = 0.65
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
