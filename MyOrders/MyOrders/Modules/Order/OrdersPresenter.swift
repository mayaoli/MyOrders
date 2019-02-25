//
//  OrdersPresenter.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-13.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

protocol OrdersEventsInterface: BaseEventsInterface {
  func prepareData()
  func getSectionNumber() -> Int?
  func getRowNumber(_ section: Int) -> Int?
  func getSectionTitle(_ section: Int) -> String?
  func getRowItem(_ indexPath: IndexPath) -> MenuOrder
}

protocol OrdersOutputInterface: BaseOutputInterface {
  
}

class OrdersPresenter: BasePresenter, OrdersEventsInterface, OrdersOutputInterface {
  
  private weak var view: OrdersViewInterface? {
    return baseView as? OrdersViewInterface
  }
  
  private var sectionData: [(String, [MenuOrder])]!
  
  func getSectionNumber() -> Int? {
    if sectionData == nil || sectionData.count == 0 {
      self.prepareData()
    }
    return sectionData.count
  }
  
  func getRowNumber(_ section: Int) -> Int? {
    if sectionData == nil || sectionData.count == 0 {
      self.prepareData()
    }
    return sectionData[section].1.count
  }
  
  func getSectionTitle(_ section: Int) -> String? {
    if sectionData == nil || sectionData.count == 0 {
      self.prepareData()
    }
    return sectionData[section].0
  }
  
  func getRowItem(_ indexPath: IndexPath) -> MenuOrder {
    let items = sectionData[indexPath.section].1
    let index = items.index(items.startIndex, offsetBy: indexPath.row)

    return items[index]
  }

  func prepareData() {
    sectionData = []
    
    if (self.view?.pending.count ?? 0) > 0 {
      sectionData.append(("Pending sent", (self.view?.pending)!))
    }
    if (self.view?.thisOrder.count ?? 0) > 0 {
      sectionData.append(("My order in waiting", (self.view?.thisOrder)!))
    }
    if (self.view?.fulfilled.count ?? 0) > 0 {
      sectionData.append(("I liked ...", (self.view?.fulfilled)!))
    }
  }
}
