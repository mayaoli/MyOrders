//
//  AddCustomerTableCell.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-11-19.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class AddCustomerTableCell: UITableViewCell {
  
  var delegate: CustomerInfoViewControl!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  @IBAction func AddTapped(_ sender: Any) {
    Bill.sharedInstance.customers?.append(Customer())
    self.delegate.tableView.reloadData()
  }
  
}
