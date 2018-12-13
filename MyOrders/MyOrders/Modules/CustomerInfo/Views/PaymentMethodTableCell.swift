//
//  PaymentMethodTableCell.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-11-17.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class PaymentMethodTableCell: UIView {
  
  var delegate: CustomerInfoViewControl!
  
  @IBOutlet weak var payMethodSegment: UISegmentedControl!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    let font: [AnyHashable : Any] = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 32)]
    
    self.payMethodSegment.removeAllSegments()
    PaymentMethod.allCases.forEach { p in
      if p != .other {
        self.payMethodSegment.insertSegment(withTitle: p.rawValue, at: p.index, animated: false)
      }
    }
    payMethodSegment.setTitleTextAttributes(font, for: .normal)
//    payMethodSegment.setWidth(132.0, forSegmentAt: 0)
//    payMethodSegment.setWidth(168.0, forSegmentAt: 1)
//    payMethodSegment.setWidth(178.0, forSegmentAt: 2)
  }
  
  @IBAction func PaymentMethodChanged(_ sender: Any) {
    Bill.sharedInstance.payment?.paymentMethod = PaymentMethod.allCases[self.payMethodSegment.selectedSegmentIndex]
  }
  
  @IBAction func PaymentMethodTapped(_ sender: Any) {
    let err = Bill.sharedInstance.validateCustomers()
    guard err == nil else {
      self.delegate.renderError(.customError(message: err!))
      return
    }
    
    self.delegate.performSegue(withIdentifier: ReuseIdentifier.toBill.rawValue, sender: nil)
  }
}
