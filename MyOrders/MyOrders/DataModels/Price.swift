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
  
  let restaurant: Restaurant?
  let lunch: Weekdays?
  let dinner: Weekdays?
  
  override init() {
    restaurant = nil
    lunch = nil
    dinner = nil
  }
  
  required init(json: JSON) throws {
    restaurant = try Restaurant(json: json["restaurant"])
    lunch = try Weekdays(json: json["lunch"])
    dinner = try Weekdays(json: json["dinner"])
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.restaurant, forKey: "restaurant")
    aCoder.encode(self.lunch, forKey: "lunch")
    aCoder.encode(self.dinner, forKey: "dinner")
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dRestaurant = aDecoder.decodeObject(forKey: "restaurant") as? Restaurant {
      self.restaurant = dRestaurant
    } else {
      self.restaurant = nil
    }
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
    guard self.sharedInstance.restaurant != nil else {
      return 0.0
    }
    
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
    
    return Double(finalPrice ?? "0")!
  }
}

class Restaurant: NSObject, NSCoding, JSONModel {
  let name: String
  let address1: String
  let address2: String
  let phone: String
  let website: String?
  
  required init(json: JSON) throws {
    name = json["name"].stringValue
    address1 = json["address1"].stringValue
    address2 = json["address2"].stringValue
    phone = json["phone"].stringValue
    website = json["website"].stringValue
  }
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.name, forKey: "name")
    aCoder.encode(self.address1, forKey: "address1")
    aCoder.encode(self.address2, forKey: "address2")
    aCoder.encode(self.phone, forKey: "phone")
    aCoder.encode(self.website, forKey: "website")
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dName = aDecoder.decodeObject(forKey: "name") as? String {
      self.name = dName
    } else {
      self.name = ""
    }
    if let dAddress1 = aDecoder.decodeObject(forKey: "address1") as? String {
      self.address1 = dAddress1
    } else {
      self.address1 = ""
    }
    if let dAddress2 = aDecoder.decodeObject(forKey: "address2") as? String {
      self.address2 = dAddress2
    } else {
      self.address2 = ""
    }
    if let dPhone = aDecoder.decodeObject(forKey: "phone") as? String {
      self.phone = dPhone
    } else {
      self.phone = ""
    }
    if let dWebsite = aDecoder.decodeObject(forKey: "website") as? String {
      self.website = dWebsite
    } else {
      self.website = nil
    }
  }
}

class Weekdays: NSObject, NSCoding, JSONModel {
  let Mon2Fri: Age?
  let Sat2Sun: Age?
  
  required init(json: JSON) throws {
    Mon2Fri = try Age(json: json["Mon2Fri"])
    Sat2Sun = try Age(json: json["Sat2Sun"])
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.Mon2Fri, forKey: "Mon2Fri")
    aCoder.encode(self.Sat2Sun, forKey: "Sat2Sun")
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dMon2Fri = aDecoder.decodeObject(forKey: "Mon2Fri") as? Age {
      self.Mon2Fri = dMon2Fri
    } else {
      self.Mon2Fri = nil
    }
    if let dSat2Sun = aDecoder.decodeObject(forKey: "Sat2Sun") as? Age {
      self.Sat2Sun = dSat2Sun
    } else {
      self.Sat2Sun = nil
    }
  }
}

class Age: NSObject, NSCoding, JSONModel {
  let adult: String   // 13-64
  let senior: String  // 65+
  let kid: [String]   // 1-12
  
  required init(json: JSON) throws {
    adult = json["adult"].stringValue
    senior = json["senior"].stringValue
    kid = try UtilityManager.getStringArray(json["kid"])
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.kid, forKey: "kid")
    aCoder.encode(self.adult, forKey: "adult")
    aCoder.encode(self.senior, forKey: "senior")
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dKid = aDecoder.decodeObject(forKey: "kid") as? [String] {
      self.kid = dKid
    } else {
      self.kid = []
    }
    if let dAdult = aDecoder.decodeObject(forKey: "adult") as? String {
      self.adult = dAdult
    } else {
      self.adult = ""
    }
    if let dSenior = aDecoder.decodeObject(forKey: "senior") as? String {
      self.senior = dSenior
    } else {
      self.senior = ""
    }
  }
}
