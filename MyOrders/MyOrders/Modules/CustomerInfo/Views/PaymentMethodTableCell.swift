//
//  PaymentMethodTableCell.swift
//  MyOrders
//
//  Created by RBC on 2018-11-17.
//  Copyright © 2018 RBC. All rights reserved.
//

import UIKit

class PaymentMethodTableCell: UITableViewCell {
  
  @IBOutlet weak var payMethodSegment: UISegmentedControl!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    self.payMethodSegment.removeAllSegments()
  
    
//    self.payMethodSegment.setTitle(<#T##title: String?##String?#>, forSegmentAt: <#T##Int#>)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
