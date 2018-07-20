//
//  Bill.swift
//  MyOrders
//
//  Created by RBC on 2018-07-10.
//  Copyright © 2018 RBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Bill: NSObject, NSCoding, JSONModel {
    
    let customers: [Customer]?
    
    // phone number
    let phoneNumber: String?
    
    /////////// delivery only
    // address
    let address: String?
    
    // orders
    let orders: [Order]
    
    // raw amount
    let rawAmount: Decimal
    
    // discount - coupon | promotion | gift card | credit
    let discount: Decimal
    
    // tax
    let tax: Decimal
    
    // cash amount
    let cashAmount: Decimal?
    
    // total amount with tax
    let totalAmount: Decimal?
    
    // payment method
    let paymentMethod: PaymentMethod
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.customers, forKey: "customers")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.orders, forKey: "orders")
        aCoder.encode(self.rawAmount, forKey: "rawAmount")
        aCoder.encode(self.discount, forKey: "discount")
        aCoder.encode(self.tax, forKey: "tax")
        aCoder.encode(self.cashAmount, forKey: "cashAmount")
        aCoder.encode(self.totalAmount, forKey: "totalAmount")
        aCoder.encode(self.paymentMethod, forKey: "paymentMethod")
    }
    
    required init?(coder aDecoder: NSCoder) {
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
        if let dorders = aDecoder.decodeObject(forKey: "orders") as? [Order]{
            orders = dorders
        } else {
            orders = []
        }
        if let drawAmount = aDecoder.decodeObject(forKey: "rawAmount") as? Decimal{
            rawAmount = drawAmount
        } else {
            rawAmount = 0
        }
        if let ddiscount = aDecoder.decodeObject(forKey: "discount") as? Decimal{
            discount = ddiscount
        } else {
            discount = 0
        }
        if let dtax = aDecoder.decodeObject(forKey: "tax") as? Decimal{
            tax = dtax
        } else {
            tax = 0
        }
        if let dcashAmount = aDecoder.decodeObject(forKey: "cashAmount") as? Decimal{
            cashAmount = dcashAmount
        } else {
            cashAmount = 0
        }
        if let dtotalAmount = aDecoder.decodeObject(forKey: "totalAmount") as? Decimal{
            totalAmount = dtotalAmount
        } else {
            totalAmount = 0
        }
        if let dpaymentMethod = aDecoder.decodeObject(forKey: "paymentMethod") as? PaymentMethod{
            paymentMethod = dpaymentMethod
        } else {
            paymentMethod = PaymentMethod.other
        }
    }
    
    required init(json: JSON) throws {
        customers = try UtilityManager.getArray(json["customers"], type: Customer.self)
        phoneNumber = json["phoneNumber"].stringValue
        address = json["address"].stringValue
        orders = try UtilityManager.getArray(json["orders"], type: Order.self)
        rawAmount = Decimal(string: json["rawAmount"].stringValue) ?? 0
        discount = Decimal(string: json["discount"].stringValue) ?? 0
        tax = Decimal(string: json["tax"].stringValue) ?? 0
        cashAmount = Decimal(string: json["cashAmount"].stringValue)
        totalAmount = Decimal(string: json["totalAmount"].stringValue)
        paymentMethod = PaymentMethod(rawValue: json["paymentMethod"].stringValue) ?? PaymentMethod.other
    }
    
    override init() {
        customers = []
        phoneNumber = ""
        address = ""
        orders = []
        rawAmount = 0
        discount = 0
        tax = 0
        cashAmount = 0
        totalAmount = 0
        paymentMethod = PaymentMethod.other
    }
}


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
