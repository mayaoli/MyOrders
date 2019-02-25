//
//  Menu.swift
//  MyOrders
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation
import SwiftyJSON

// Food
class Menu: NSObject, NSCoding, JSONModel {
  
  let categoryId: String
  let categoryName: String
  let isHot: Bool
  let menuItems: [MenuItem]
  
  override init() {
    categoryId = ""
    categoryName = ""
    isHot = true
    menuItems = []
  }
  
  required init(json: JSON) throws {
    categoryId = json["categoryId"].stringValue
    categoryName = json["name"].stringValue
    isHot = json["isHot"].boolValue
    menuItems = try UtilityManager.getArray(json["items"], type: MenuItem.self)
    menuItems.forEach{ (item) in
      item.category = json["categoryId"].stringValue
      item.isHot = json["isHot"].boolValue
    }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.categoryId, forKey: "categoryId")
    aCoder.encode(self.categoryName, forKey: "name")
    aCoder.encode(self.isHot, forKey: "isHot")
    aCoder.encode(self.menuItems, forKey: "items")
  }
  
  required init?(coder aDecoder: NSCoder) {
    if let dcategoryId = aDecoder.decodeObject(forKey: "categoryId") as? String {
      categoryId = dcategoryId
    } else {
      categoryId = ""
    }
    if let dcategoryName = aDecoder.decodeObject(forKey: "name") as? String {
      categoryName = dcategoryName
    } else {
      categoryName = ""
    }
    if let dhot = aDecoder.decodeObject(forKey: "isHot") as? Bool{
      isHot = dhot
    } else {
      isHot = true
    }
    if let dmenuItems = aDecoder.decodeObject(forKey: "items") as? [MenuItem] {
      menuItems = dmenuItems
    } else {
      menuItems = []
    }
  }
}

class MenuItem: NSObject, NSCoding, JSONModel {
  
  // menu item id
  let mid: String
  
  // category - Appetizers|Soup|Salad|...
  var category: String
  
  // image url
  let imageURL: String?
  
  // name
  let name: String
  
  // short descriptionion
  let shortDescription: String
  
  // price
  let price: Double?
  
  // is hot or cold
  var isHot: Bool
  
  // orderType - delivery|pick-up/take-out|eat-in
  let orderAvailability: OrderType
  
  // mark as new item
  let isNewItem: Bool
  
  var payload: [String : String] {
    return [
      "id": self.mid,
      "img": self.imageURL ?? "",
      "name": self.name,
      "description": self.shortDescription,
      "category": self.category,
      "price": self.price?.description ?? "",
      "isHot": self.isHot.description,
      "orderType": self.orderAvailability.rawValue,
      "isNewItem": self.isNewItem.description
    ]
  }
  
  var key: String {
    // status as part of the key
    return "C\(category)-I\(mid)-S\(OrderStatus.pending.hashValue)"
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.mid, forKey: "id")
    aCoder.encode(self.imageURL, forKey: "img")
    aCoder.encode(self.name, forKey: "name")
    aCoder.encode(self.shortDescription, forKey: "description")
    aCoder.encode(self.category, forKey: "category")
    aCoder.encode(self.price, forKey: "price")
    aCoder.encode(self.isHot, forKey: "ishot")
    aCoder.encode(self.orderAvailability.rawValue, forKey: "ordertype")
    aCoder.encode(self.isNewItem, forKey: "isnewitem")
  }
  
  override init() {
    mid = ""
    imageURL = ""
    name = ""
    shortDescription = ""
    category = ""
    price = nil
    isHot = false
    orderAvailability = OrderType.all
    isNewItem = false
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    if let dmid = aDecoder.decodeObject(forKey: "id") as? String{
      mid = dmid
    } else {
      mid = ""
    }
    if let dimageURL = aDecoder.decodeObject(forKey: "img") as? String{
      imageURL = dimageURL
    } else {
      imageURL = ""
    }
    if let dname = aDecoder.decodeObject(forKey: "name") as? String{
      name = dname
    } else {
      name = ""
    }
    if let dshortDescription = aDecoder.decodeObject(forKey: "description") as? String{
      shortDescription = dshortDescription
    } else {
      shortDescription = ""
    }
    if let dcategory = aDecoder.decodeObject(forKey: "category") as? String{
      category = dcategory
    } else {
      category = ""
    }
    if let dprice = aDecoder.decodeObject(forKey: "price") as? Double {
      price = dprice
    } else {
      price = 0
    }
    if let disHot = aDecoder.decodeObject(forKey: "ishot") as? Bool {
      isHot = disHot
    } else {
      isHot = aDecoder.decodeBool(forKey: "ishot")
    }
    if let dType = aDecoder.decodeObject(forKey: "ordertype") as? String {
      orderAvailability = OrderType(rawValue: dType)!
    } else {
      orderAvailability = .all
    }
    if let disNewItem = aDecoder.decodeObject(forKey: "isnewitem") as? Bool {
      isNewItem = disNewItem
    } else {
      isNewItem = aDecoder.decodeBool(forKey: "isnewitem")
    }
  }
  
  required init(json: JSON) throws {
    mid = json["id"].stringValue
    imageURL = json["img"].stringValue
    name = json["name"].stringValue
    shortDescription = json["description"].stringValue
    category = ""
    price = Double(json["price"].stringValue)
    isHot = json["isHot"].boolValue
    orderAvailability = OrderType.init(rawValue: json["orderType"].stringValue) ?? OrderType.all
    isNewItem = json["isNewItem"].boolValue
  }
  
}

