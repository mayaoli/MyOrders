//
//  MenuCollectionCell.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-27.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class MenuCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var itemImage: UIImageView!
  @IBOutlet weak var itemName: UILabel!
  
  var menuItem: MenuItem! {
    didSet {
      if menuItem.imageURL != nil {
        itemImage.imageFromUrl(menuItem.imageURL!)
      }
      itemName.text = menuItem.name // + " \(menuItem.shortDescription)"
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    self.roundCorners([.allCorners], radius: 20)
    
  }
  
}
