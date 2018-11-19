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
    aCoder.encode(self.priceRange, forKey: "priceRange")
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
    if let dpriceRange = aDecoder.decodeObject(forKey: "priceRange") as? PriceRange {
      priceRange = dpriceRange
    } else {
      priceRange = .none
    }
  }
  
  required init(json: JSON) throws {
    customerName = json["customerName"].stringValue
    priceRange = PriceRange(rawValue: json["priceRange"]) ?? .none
  }
  
}
