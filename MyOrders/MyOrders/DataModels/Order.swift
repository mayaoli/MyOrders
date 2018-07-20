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
    let orderId: String
    
    // table#
    let tableNumber: String?
    
    // food
    let food: [Menu:FoodStatus]
    
    // orderType
    let orderType: OrderType // delivery|pick-up/take-out|eat-in
    
    // split pay - split the payment for each customer
    let splitPay: Bool
    
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.orderId, forKey: "orderId")
        aCoder.encode(self.tableNumber, forKey: "tableNumber")
        aCoder.encode(self.food, forKey: "food")
        aCoder.encode(self.orderType, forKey: "orderType")
        aCoder.encode(self.splitPay, forKey: "splitPay")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let dorderId = aDecoder.decodeObject(forKey: "orderId") as? String{
            orderId = dorderId
        } else {
            orderId = ""
        }
        if let dtableNumber = aDecoder.decodeObject(forKey: "tableNumber") as? String{
            tableNumber = dtableNumber
        } else {
            tableNumber = ""
        }
        if let dfood = aDecoder.decodeObject(forKey: "food") as? [Menu:FoodStatus]{
            food = dfood
        } else {
            food = [:]
        }
        if let dType = aDecoder.decodeObject(forKey: "orderType") as? OrderType{
            orderType = dType
        } else {
            orderType = OrderType.eatin
        }
        if let dsplitPay = aDecoder.decodeObject(forKey: "splitPay") as? Bool{
            splitPay = dsplitPay
        } else {
            splitPay = false
        }
    }
    
    required init(json: JSON) throws {
        orderId = json["orderId"].stringValue
        tableNumber = json["tableNumber"].stringValue
        food = [:]  //UtilityManager.getArray(json["food"], type: nil)
        orderType = OrderType.init(rawValue: json["orderType"].stringValue) ?? OrderType.eatin
        splitPay = json["splitPay"].boolValue
    }
    
    override init() {
        orderId = ""
        tableNumber = ""
        food = [:]
        orderType = OrderType.eatin
        splitPay = false
    }
    
}

