//
//  UtilityManager.swift
//  MyOrders
//
//  Created by RBC on 2018-07-12.
//  Copyright © 2018 RBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class UtilityManager {
    
    /**
     Get an array of serialized objects from a JSON array.
     
     Requires that the model inherits JSONModel because of Swift's contraints: "Constructing an object of class
     type 'T' with a metatype value must use a 'required' initializer")
     
     Meaning to add a required init method on BaseDataModel causes all models to break without syntax changes and
     adding said required init on some of them.
     
     - parameter jsonArray: The JSON array
     - parameter type: The type of object you want serialized
     - parameter transform: An optional transformation block to mutate each item upon instatiating it
     */
    class func getArray<T: JSONModel>(_ jsonArray: JSON, type: T.Type, transform: ((_ item: T) -> Void)? = nil) throws -> [T] {
        var items: [T] = []
        for i in 0 ..< jsonArray.count {
            // Weird Swift syntax: you have to actually call init on something of type 'Type', you can't just use
            // type(json: ...)
            let item = try type.init(json: jsonArray[i])
            if let transform = transform {
                transform(item)
            }
            items.append(item)
        }
        return items
    }
}
