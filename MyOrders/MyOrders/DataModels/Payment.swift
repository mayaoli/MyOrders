//
//  Payment.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-24.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Payment {
  // pay by per order | all you can eat
  var byOrder: Bool = false
  
  // split pay - split the payment for each customer
  var splitPay: Bool = false
  
  // payment method
  var paymentMethod: PaymentMethod = .other
  
  // raw amount
  var rawAmount: Double = 0
  
  // discount - coupon | promotion | group| birthday | gift card | credit points
  var discount: Double = 0
  
  // deliver charge if any
  var deliverFee: Double = 0
  
  // tax
  var tax: Double {
    get {
      guard rawAmount > 0 else {
        return 0
      }
      
      return rawAmount * 0.13
    }
    set { }
  }
  
  // cash amount
  var cashAmount: Double? {
    get {
      guard rawAmount > 0 else {
        return 0
      }
      guard tax > 0 else {
        return rawAmount
      }
      
      guard paymentMethod == .cash else {
        return (rawAmount + tax)
      }
      
      return rawAmount + (tax * Constants.DISCOUNT_RATE / 0.13)
    }
    set { }
  }
  
  // total amount with tax
  var totalAmount: Double?
  
  init(json: JSON) throws {
    byOrder = json["byOrder"].boolValue
    splitPay = json["splitPay"].boolValue
    paymentMethod = PaymentMethod(rawValue: json["paymentMethod"].stringValue) ?? PaymentMethod.other
    rawAmount = Double(json["rawAmount"].stringValue) ?? 0
    discount = Double(json["discount"].stringValue) ?? 0
    tax = Double(json["tax"].stringValue) ?? 0
    cashAmount = Double(json["cashAmount"].stringValue)
    totalAmount = Double(json["totalAmount"].stringValue)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.byOrder, forKey: "byOrder")
    aCoder.encode(self.splitPay, forKey: "splitPay")
    aCoder.encode(self.paymentMethod, forKey: "paymentMethod")
    aCoder.encode(self.rawAmount, forKey: "rawAmount")
    aCoder.encode(self.discount, forKey: "discount")
    aCoder.encode(self.tax, forKey: "tax")
    aCoder.encode(self.cashAmount, forKey: "cashAmount")
    aCoder.encode(self.totalAmount, forKey: "totalAmount")
  }
  
  init?(coder aDecoder: NSCoder) {
    if let dByOrder = aDecoder.decodeObject(forKey: "byOrder") as? Bool {
      byOrder = dByOrder
    } else {
      byOrder = false
    }
    if let dSplitPay = aDecoder.decodeObject(forKey: "splitPay") as? Bool {
      splitPay = dSplitPay
    } else {
      splitPay = false
    }
    if let dpaymentMethod = aDecoder.decodeObject(forKey: "paymentMethod") as? PaymentMethod{
      paymentMethod = dpaymentMethod
    } else {
      paymentMethod = PaymentMethod.other
    }
    if let drawAmount = aDecoder.decodeObject(forKey: "rawAmount") as? Double{
      rawAmount = drawAmount
    } else {
      rawAmount = 0
    }
    if let ddiscount = aDecoder.decodeObject(forKey: "discount") as? Double{
      discount = ddiscount
    } else {
      discount = 0
    }
    if let dtax = aDecoder.decodeObject(forKey: "tax") as? Double{
      tax = dtax
    } else {
      tax = 0
    }
    if let dcashAmount = aDecoder.decodeObject(forKey: "cashAmount") as? Double{
      cashAmount = dcashAmount
    } else {
      cashAmount = 0
    }
    if let dtotalAmount = aDecoder.decodeObject(forKey: "totalAmount") as? Double{
      totalAmount = dtotalAmount
    } else {
      totalAmount = 0
    }
  }
}

