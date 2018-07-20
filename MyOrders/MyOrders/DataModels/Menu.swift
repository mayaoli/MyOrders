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
    
    // menu item id
    let mid: String
    
    // image url
    let imageURL: String?
    
    // name
    let name: String
    
    // short descriptionion
    let shortDescription: String
    
    // category - Appetizers|Soup|Salad|...
    let category: String
    
    // price
    let price: Decimal?
    
    // is hot or cold
    let isHot: Bool
    
    // orderType - delivery|pick-up/take-out|eat-in
    let orderType: OrderType
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.mid, forKey: "id")
        aCoder.encode(self.imageURL, forKey: "img")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.shortDescription, forKey: "description")
        aCoder.encode(self.category, forKey: "category")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.isHot, forKey: "ishot")
        aCoder.encode(self.orderType, forKey: "orderType")
    }
    
    override init() {
        mid = ""
        imageURL = ""
        name = ""
        shortDescription = ""
        category = ""
        price = 0
        isHot = true
        orderType = OrderType.eatin
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
        if let dprice = aDecoder.decodeObject(forKey: "price") as? Decimal{
            price = dprice
        } else {
            price = 0
        }
        if let dhot = aDecoder.decodeObject(forKey: "isHot") as? Bool{
            isHot = dhot
        } else {
            isHot = true
        }
        if let dType = aDecoder.decodeObject(forKey: "orderType") as? OrderType{
            orderType = dType
        } else {
            orderType = OrderType.eatin
        }
    }
    
    required init(json: JSON) throws {
        mid = json["id"].stringValue
        imageURL = json["img"].stringValue
        name = json["name"].stringValue
        shortDescription = json["description"].stringValue
        category = json["category"].stringValue
        price = Decimal(string: json["price"].stringValue)
        isHot = json["isHot"].boolValue
        orderType = OrderType.init(rawValue: json["orderType"].stringValue) ?? OrderType.eatin
    }
    
    var payload: [String : String] {
        return [
            "id": self.mid,
            "img": self.imageURL ?? "",
            "name": self.name,
            "description": self.shortDescription,
            "category": self.category,
            "price": self.price?.description ?? "",
            "isHot": self.isHot.description,
            "orderType": self.orderType.rawValue
        ]
    }
    
}

