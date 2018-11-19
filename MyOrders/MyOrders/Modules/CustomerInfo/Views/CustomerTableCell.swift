//
//  CustomerTableCell.swift
//  MyOrders
//
//  Created by RBC on 2018-10-27.
//  Copyright © 2018 RBC. All rights reserved.
//


import UIKit

class CustomerTableCell: UITableViewCell {

  @IBOutlet weak var sequenceNum: UILabel!
  @IBOutlet weak var customerName: UILabel!
  @IBOutlet weak var age: UILabel!
  
  var thisCustomer: Customer! {
    didSet {
      if let cname = thisCustomer.customerName, !cname.isEmpty {
        self.customerName.text = cname
      } else {
        self.customerName.text = "customer"
      }
      
      self.age.text = thisCustomer.priceRange.description
      if thisCustomer.priceRange == PriceRange.none {
        self.age.textColor = UIColor.textFieldErrorColor
      } else {
        self.age.textColor = UIColor.black
      }
    }
  }
  
  var delegate: UIViewController!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  @IBAction func removeTapped(_ sender: Any) {
    (delegate as! CustomerInfoViewControl).removeCustomer(thisCustomer)
  }
  
}
