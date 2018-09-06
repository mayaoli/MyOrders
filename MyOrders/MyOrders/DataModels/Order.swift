//
//  Order.swift
//  MyOrders
//
//  Created by Yaoli Ma on 2018-07-10.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation
import SwiftyJSON

class Order: NSObject, NSCoding, JSONModel {
    
    // order id - generated, useful for delivery
    var orderId: String
    
    // ordered items
    var items: [String:MenuOrder]
    
    // orderType
    var orderType: OrderType // delivery|pick-up/take-out|eat-in(by-order/lunch-buffet/dinner-buffet)
  
  
  //TODO: add order time
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.orderId, forKey: "orderId")
        aCoder.encode(self.items, forKey: "orderItems")
        aCoder.encode(self.orderType.rawValue, forKey: "orderType")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let dOrderId = aDecoder.decodeObject(forKey: "orderId") as? String {
            orderId = dOrderId
        } else {
            orderId = ""
        }
        if let dItems = aDecoder.decodeObject(forKey: "orderItems") as? [String:MenuOrder] {
            items = dItems
        } else {
          items = [:]
        }
        if let dType = aDecoder.decodeObject(forKey: "orderType") as? String {
            orderType = OrderType(rawValue: dType)!
        } else {
            orderType = OrderType.all
        }
    }
    
    required init(json: JSON) throws {
      orderId = json["orderId"].stringValue
      orderType = OrderType.init(rawValue: json["orderType"].stringValue) ?? OrderType.all
      items = [:]
      let ods = try UtilityManager.getArray(json["orderItems"], type: MenuOrder.self)
      for x in ods {
        items[x.key] = x
      }
    }
    
    override init() {
      orderId = ""
      items = [:]
      orderType = OrderType.all
    }
    
}

class MenuOrder: MenuItem {
  var status: OrderStatus
  var quantity: Int
  
  
  var pushPayload: JSON {
    return JSON.init([])
  }
  
  override var key: String {
    return "C\(category)-I\(mid)-S\(status.hashValue)"
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dStatus = aDecoder.decodeObject(forKey: "status") as? String {
      status = OrderStatus(rawValue: dStatus)!
    } else {
      status = OrderStatus.pending
    }
    if let dQuantity = aDecoder.decodeObject(forKey: "quantity") as? String, !dQuantity.isEmpty {
      quantity = (dQuantity as NSString).integerValue
    } else {
      quantity = 0
    }
    
    super.init(coder: aDecoder)
  }
  
  override func encode(with aCoder: NSCoder) {
    aCoder.encode(self.status.rawValue, forKey: "status")
    aCoder.encode(String(self.quantity), forKey: "quantity")
    
    super.encode(with: aCoder)
  }
  
  required init(json: JSON) throws {
    status = OrderStatus.init(rawValue: json["status"].stringValue) ?? OrderStatus.pending
    quantity = json["quantity"].intValue
    
    try! super.init(json: json)
  }
  
  override init() {
    status = OrderStatus.pending
    quantity = 1
    
    super.init()
  }
  
  convenience init(item: MenuItem) {
    try! self.init(json: JSON.init(item.payload))
    
    status = OrderStatus.pending
    quantity = 1
  }
}

