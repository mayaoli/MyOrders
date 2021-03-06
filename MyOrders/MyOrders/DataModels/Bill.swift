//
//  Bill.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-10.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation
import SwiftyJSON

class Bill: NSObject, NSCoding, JSONModel {
  
  static var sharedInstance = Bill()
  
  // table#
  var tableNumber: String?
  
  var staffPIN: String!
  
  var billPIN: String!
  
  var customers: [Customer]?
  
  // phone number
  var phoneNumber: String?
  
  /////////// delivery only
  // address
  var address: String?
  
  // orders
  var order: Order?
  
  var payment: Payment?
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.tableNumber, forKey: "tableNumber")
    aCoder.encode(self.staffPIN, forKey: "staffPIN")
    aCoder.encode(self.billPIN, forKey: "billPIN")
    aCoder.encode(self.customers, forKey: "customers")
    aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
    aCoder.encode(self.address, forKey: "address")
    aCoder.encode(self.order, forKey: "orders")
    aCoder.encode(self.payment, forKey: "payment")
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
    if let dbillPIN = aDecoder.decodeObject(forKey: "billPIN") as? String{
      billPIN = dbillPIN
    } else {
      billPIN = ""
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
    if let dorders = aDecoder.decodeObject(forKey: "orders") as? Order{
      order = dorders
    } else {
      order = nil
    }
    if let dpayment = aDecoder.decodeObject(forKey: "payment") as? Payment{
      payment = dpayment
    } else {
      payment = nil
    }
  }
  
  required init(json: JSON) throws {
    tableNumber = json["tableNumber"].stringValue
    staffPIN = json["staffPIN"].stringValue
    billPIN = json["billPIN"].stringValue
    customers = try UtilityManager.getArray(json["customers"], type: Customer.self)
    phoneNumber = json["phoneNumber"].stringValue
    address = json["address"].stringValue
    order = try? Order(json: json["orders"])
    payment = try? Payment(json: json["payment"])
  }
  
  override init() {
    tableNumber = "0"
    staffPIN = "****"
    billPIN = "****"
    customers = []
    phoneNumber = "-"
    address = "-"
    order = nil
    payment = nil
  }
  
  func validateCustomers()-> String? {
    guard self.customers != nil, self.customers!.count > 0 else {
      return nil
    }
    
    for c in self.customers! {
      if c.priceRange == .none {
        return "All the customer must be configured!"
      }
    }
    
    return nil
  }
  
  func creatPayment()-> Bool {
    guard self.payment != nil, self.payment?.paymentMethod != .other else {
      return false
    }
    
    if order?.orderType == .lunchBuffet || order?.orderType == .dinnerBuffet {
      return calculateBuffetBill()
    } else if order?.orderType == .eatInByOrder || order?.orderType == .delivery || order?.orderType == .pickupOrTakeout {
      return calculateOrderBill()
    }
    
    return false
  }
  
  func calculateOrderBill()-> Bool {
    guard let orderItems = order?.items, !orderItems.isEmpty else {
      return false
    }
    
    self.payment?.rawAmount = 0
    
    if order!.isByOrder {
      orderItems.forEach { (item) in
        self.payment?.rawAmount += item.value.price! * Double(item.value.quantity)
      }
    } else {
      return false
    }
    
    return true
  }
  
  func calculateBuffetBill()-> Bool {
    guard self.order != nil, self.customers != nil, self.customers!.contains(where: { $0.priceRange.age != 0 }) else {
      return false
    }
    
    self.payment?.rawAmount = 0
    
    if order!.isBuffet {
      customers?.forEach({ (customer) in
        self.payment?.rawAmount += Price.getAmount((order?.orderType)!, customer.priceRange.age)
      })
      
      order?.items.filter{  $0.1.status != .pending && $0.1.orderAvailability == .eatInByOrder }.forEach({ (item) in
        self.payment?.rawAmount += item.value.price! * Double(item.value.quantity)
      })
    } else {
      return false
    }
    
    return true
  }
  
  func reset() {
    tableNumber = "0"
    staffPIN = "****"
    billPIN = "****"
    customers = []
    phoneNumber = "-"
    address = "-"
    order = nil
    payment = nil
    
    _ = StorageManager.deleteObject(path: Constants.STORAGE_ORDER_PATH)
    _ = StorageManager.deleteObject(path: Constants.STORAGE_CUSTOMER_PATH)
  }
}
