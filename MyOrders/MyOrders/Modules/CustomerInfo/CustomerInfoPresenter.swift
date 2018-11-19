//
//  CustomerInfoPresenter.swift
//  MyOrders
//
//  Created by RBC on 2018-10-31.
//  Copyright © 2018 RBC. All rights reserved.
//

import Foundation


protocol CustomerEventsInterface: BaseEventsInterface {
  func getRowNumber(_ section: Int) -> Int?
  func getPriceRange(_ index: UInt) -> PriceRange
}

class CustomerPresenter: BasePresenter, CustomerEventsInterface {
  
  func getRowNumber(_ section: Int) -> Int? {
    if section == 0 {
      return (Bill.sharedInstance.customers?.count ?? 1) + 1
    }
    
    return 1
  }
  
  func getPriceRange(_ age: UInt) -> PriceRange {
    switch age {
    case 30:
      return PriceRange.adult
    case 65:
      return PriceRange.senior
    default:
      return PriceRange.kid(age: age)
    }
  }
  
  
  
}
