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
  
  var customerName: String?
  
  var priceRange: PriceRange
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.customerName, forKey: "customerName")
    aCoder.encode(self.priceRange.index, forKey: "priceRange.index")
    aCoder.encode(self.priceRange.age, forKey: "priceRange.age")
  }
  
  override init() {
    customerName = ""
    priceRange = .none
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dcustomerName = aDecoder.decodeObject(forKey: "customerName") as? String {
      customerName = dcustomerName
    } else {
      customerName = ""
    }
    
    let dpriceRangeIndex = aDecoder.decodeInteger(forKey: "priceRange.index")
    let dpriceRangeAge = aDecoder.decodeObject(forKey: "priceRange.age") as? UInt ?? 0
    priceRange = PriceRange.init(index: dpriceRangeIndex, age: dpriceRangeAge) ?? .none
  }
  
  required init(json: JSON) throws {
    customerName = json["customerName"].stringValue
    priceRange = PriceRange(rawValue: json["priceRange"]) ?? .none
  }
  
}
