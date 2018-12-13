//
//  MYLDouble.swift
//  MyOrders
//
//  Created by RBC on 2018-12-05.
//  Copyright © 2018 RBC. All rights reserved.
//

import Foundation

extension Double {
  
  func toCurrency() -> String {
    return String(format: "$%.2f", self)
  }
  
}
