//
//  CategoryCollectionCell.swift
//  MyOrders
//
//  Created by RBC on 2019-01-31.
//  Copyright © 2019 RBC. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {

  @IBOutlet weak var categoryLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  }

  var categoryName: String! {
    didSet {
      self.categoryLabel.text = categoryName
    }
  }
  
}
