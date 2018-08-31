//
//  OrderTableCell.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-13.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class OrderTableCell: UITableViewCell {

  @IBOutlet weak var sequenceNum: UILabel!
  @IBOutlet weak var statusImage: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var itemName: UILabel!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var quantity: UILabel!
  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var price: UILabel!
  
  var thisItem: MenuOrder! {
    //TODO: need more images
    didSet {
      addButton.isHidden = true
      removeButton.isHidden = true
      
      switch thisItem.status {
      case .pending:
        statusImage.image = #imageLiteral(resourceName: "pending")
        addButton.isHidden = false
        removeButton.isHidden = false
      case .new:
        statusImage.image = #imageLiteral(resourceName: "new")
      case .processing:
        statusImage.image = #imageLiteral(resourceName: "processing")
      case .ready:
        statusImage.image = #imageLiteral(resourceName: "ready")
      case .fulfilled:
        statusImage.image = #imageLiteral(resourceName: "fulfilled")
//      default:
//        statusImage.image = #imageLiteral(resourceName: "order")
      }
      statusLabel.text = thisItem.status.rawValue
      itemName.text = thisItem.name
      quantity.text = "Qty: \(thisItem.quantity)"
      if thisItem.price == nil {
        price.isHidden = true
      } else {
        price.text = "$\(thisItem.price!)"
      }
    }
  }
  
  weak var delegate: UIViewController!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    self.addButton.setImage(#imageLiteral(resourceName: "add_grey"), for: UIControlState.highlighted)
    self.removeButton.setImage(#imageLiteral(resourceName: "remove_grey"), for: UIControlState.highlighted)
  }

//  override func setSelected(_ selected: Bool, animated: Bool) {
//      super.setSelected(selected, animated: animated)
//
//      // Configure the view for the selected state
//  }
  
  @IBAction func addTapped(_ sender: Any) {
    thisItem.quantity += 1
    quantity.text = String(thisItem.quantity)
    
    (self.delegate as! OrdersViewInterface).refreshView(false)
  }
  
  @IBAction func removeTapped(_ sender: Any) {
    if thisItem.quantity > 1 {
      thisItem.quantity -= 1
      quantity.text = String(thisItem.quantity)
      (self.delegate as! OrdersViewInterface).refreshView(false)
    } else {
      // TODO: need add status as part of the key
      Bill.sharedInstance.order!.items.removeValue(forKey: thisItem.key)
      (self.delegate as! OrdersViewInterface).refreshView(true)
    }
  }
  
}
