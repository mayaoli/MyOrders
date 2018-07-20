//
//  MYLImageView.swift
//  MyOrders
//
//  Created by RBC on 2018-07-17.
//  Copyright © 2018 RBC. All rights reserved.
//

import SDWebImage

extension UIImageView {
  
  func imageFromUrl(_ urlString: String, placeHolder: UIImage? = #imageLiteral(resourceName: "NoImage") , completion: ((_ success: Bool) -> Void)? = nil) {
    if let url = URL(string: urlString) {
      self.sd_setImage(with: url, placeholderImage: placeHolder, options: SDWebImageOptions(), completed: { (_, error, _, _) in
        if let block = completion {
          block(error == nil)
        }
      })
      
    }
  }
}
