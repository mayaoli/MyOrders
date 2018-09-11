//
//  Price.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-29.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation
import SwiftyJSON


class Price: NSObject, NSCoding, JSONModel {
  
  static var sharedInstance = Price()
  
  let lunch: Weekdays?
  let dinner: Weekdays?
  
  override init() {
    lunch = nil
    dinner = nil
  }
  
  required init(json: JSON) throws {
    lunch = try Weekdays(json: json["lunch"])
    dinner = try Weekdays(json: json["dinner"])
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.lunch, forKey: "lunch")
    aCoder.encode(self.dinner, forKey: "dinner")
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dLunch = aDecoder.decodeObject(forKey: "lunch") as? Weekdays {
      self.lunch = dLunch
    } else {
      self.lunch = nil
    }
    if let dDinner = aDecoder.decodeObject(forKey: "dinner") as? Weekdays {
      self.dinner = dDinner
    } else {
      self.dinner = nil
    }
  }
  
  open class func getAmount(_ type: OrderType, _ age: UInt) -> Double {
    var weekPrice : Weekdays?
    if type == .lunchBuffet {
      weekPrice = self.sharedInstance.lunch
    } else if type == .dinnerBuffet {
      weekPrice = self.sharedInstance.dinner
    }
    
    var agePrice : Age?
    if Calendar.current.dateComponents([.weekday], from: Date()).weekday! > 5 {
      agePrice = weekPrice?.Sat2Sun
    } else {
      agePrice = weekPrice?.Mon2Fri
    }
    
    var finalPrice: String?
    switch age {
    case 3..<12:
      finalPrice = agePrice?.kid[Int(age)-3]
    case 13..<64:
      finalPrice = agePrice?.adult
    default:
      finalPrice = agePrice?.senior
    }
    
    if let val = Double(finalPrice!) {
      return val
    }
    
    return 0.0
  }
}

class Weekdays {
  let Mon2Fri: Age
  let Sat2Sun: Age
  
  required init(json: JSON) throws {
    Mon2Fri = try Age(json: json["Mon2Fri"])
    Sat2Sun = try Age(json: json["Sat2Sun"])
  }
}

class Age {
  let kid: [String]     // 1-12
  let adult: String   // 13-64
  let senior: String  // 65+
  
  required init(json: JSON) throws {
    kid = try UtilityManager.getArray(json["kid"], type: String)
    adult = json["adult"].stringValue
    senior = json["senior"].stringValue
  }
}
