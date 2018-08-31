//
//  Customer.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-29.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation
import SwiftyJSON

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
