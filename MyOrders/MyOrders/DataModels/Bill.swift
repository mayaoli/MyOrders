//
//  Bill.swift
//  MyOrders
//
//  Created by RBC on 2018-07-10.
//  Copyright © 2018 RBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Bill: NSObject, NSCoding, JSONModel {
  
  static var sharedInstance = Bill()
  
  // table#
  var tableNumber: String?
  
  var staffPIN: String!
  
  var customers: [Customer]?
  
  // phone number
  var phoneNumber: String?
  
  /////////// delivery only
  // address
  var address: String?
  
  // orders
  var orders: [Order]
  
  // raw amount
  var rawAmount: Decimal
  
  // discount - coupon | promotion | gift card | credit
  var discount: Decimal
  
  // tax
  var tax: Decimal
  
  // cash amount
  var cashAmount: Decimal?
  
  // total amount with tax
  var totalAmount: Decimal?
  
  // payment method
  var paymentMethod: PaymentMethod
  
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.tableNumber, forKey: "tableNumber")
    aCoder.encode(self.staffPIN, forKey: "staffPIN")
    aCoder.encode(self.customers, forKey: "customers")
    aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
    aCoder.encode(self.address, forKey: "address")
    aCoder.encode(self.orders, forKey: "orders")
    aCoder.encode(self.rawAmount, forKey: "rawAmount")
    aCoder.encode(self.discount, forKey: "discount")
    aCoder.encode(self.tax, forKey: "tax")
    aCoder.encode(self.cashAmount, forKey: "cashAmount")
    aCoder.encode(self.totalAmount, forKey: "totalAmount")
    aCoder.encode(self.paymentMethod, forKey: "paymentMethod")
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dtableNumber = aDecoder.decodeObject(forKey: "tableNumber") as? String{
      tableNumber = dtableNumber
    } else {
      tableNumber = ""
    }
    if let dstaffPIN = aDecoder.decodeObject(forKey: "staffPIN") as? String{
      staffPIN = dstaffPIN
    } else {
      staffPIN = ""
    }
    if let dcustomers = aDecoder.decodeObject(forKey: "customers") as? [Customer]{
        customers = dcustomers
    } else {
        customers = []
    }
    if let dphoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String{
        phoneNumber = dphoneNumber
    } else {
        phoneNumber = ""
    }
    if let daddress = aDecoder.decodeObject(forKey: "address") as? String{
        address = daddress
    } else {
        address = ""
    }
    if let dorders = aDecoder.decodeObject(forKey: "orders") as? [Order]{
        orders = dorders
    } else {
        orders = []
    }
    if let drawAmount = aDecoder.decodeObject(forKey: "rawAmount") as? Decimal{
        rawAmount = drawAmount
    } else {
        rawAmount = 0
    }
    if let ddiscount = aDecoder.decodeObject(forKey: "discount") as? Decimal{
        discount = ddiscount
    } else {
        discount = 0
    }
    if let dtax = aDecoder.decodeObject(forKey: "tax") as? Decimal{
        tax = dtax
    } else {
        tax = 0
    }
    if let dcashAmount = aDecoder.decodeObject(forKey: "cashAmount") as? Decimal{
        cashAmount = dcashAmount
    } else {
        cashAmount = 0
    }
    if let dtotalAmount = aDecoder.decodeObject(forKey: "totalAmount") as? Decimal{
        totalAmount = dtotalAmount
    } else {
        totalAmount = 0
    }
    if let dpaymentMethod = aDecoder.decodeObject(forKey: "paymentMethod") as? PaymentMethod{
        paymentMethod = dpaymentMethod
    } else {
        paymentMethod = PaymentMethod.other
    }
  }
  
  required init(json: JSON) throws {
    tableNumber = json["tableNumber"].stringValue
    staffPIN = json["staffPIN"].stringValue
    customers = try UtilityManager.getArray(json["customers"], type: Customer.self)
    phoneNumber = json["phoneNumber"].stringValue
    address = json["address"].stringValue
    orders = try UtilityManager.getArray(json["orders"], type: Order.self)
    rawAmount = Decimal(string: json["rawAmount"].stringValue) ?? 0
    discount = Decimal(string: json["discount"].stringValue) ?? 0
    tax = Decimal(string: json["tax"].stringValue) ?? 0
    cashAmount = Decimal(string: json["cashAmount"].stringValue)
    totalAmount = Decimal(string: json["totalAmount"].stringValue)
    paymentMethod = PaymentMethod(rawValue: json["paymentMethod"].stringValue) ?? PaymentMethod.other
  }
  
  override init() {
    tableNumber = "0"
    staffPIN = "****"
    customers = []
    phoneNumber = "-"
    address = "-"
    orders = []
    rawAmount = 0
    discount = 0
    tax = 0
    cashAmount = 0
    totalAmount = 0
    paymentMethod = PaymentMethod.other
  }
}


class Customer: NSObject, NSCoding, JSONModel {
    
    let customerName: String?
    
    let age: UInt?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.customerName, forKey: "customerName")
        aCoder.encode(self.age, forKey: "age")
    }
    
    override init() {
      customerName = ""
      age = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let dcustomerName = aDecoder.decodeObject(forKey: "customerName") as? String{
            customerName = dcustomerName
        } else {
            customerName = ""
        }
        if let dage = aDecoder.decodeObject(forKey: "age") as? UInt{
            age = dage
        } else {
            age = 0
        }
    }
    
    required init(json: JSON) throws {
        customerName = json["customerName"].stringValue
        age = json["age"].uIntValue
    }
    
}
