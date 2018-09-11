//
//  BillPresenter.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-30.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

protocol BillEventsInterface: BaseEventsInterface {
  func getPrice()
  func getRowNumber(_ section: Int) -> Int?
}

protocol BillOutputInterface: BaseOutputInterface {
  func gotPrice(_ error: NetworkingError?)
}

class BillPresenter: BasePresenter, BillEventsInterface, BillOutputInterface {
  
  private weak var view: BillViewInterface? {
    return baseView as? BillViewInterface
  }
  private weak var interactor: BillInteractorInput? {
    return baseInteractor as? BillInteractorInput
  }
  
  override func createInteractor() -> BaseInteractor {
    return BillInteractor()
  }
  
  // MARK: BillEventsInterface
  func getPrice() {
    if Price.sharedInstance.lunch == nil || Price.sharedInstance.dinner == nil {
      self.interactor?.retrievePrice()
    } else {
      self.gotPrice(nil)
    }
  }
  
  func getRowNumber(_ section: Int) -> Int? {
    guard let order = Bill.sharedInstance.order else {
      return 0
    }
    
    switch section {
    case 1: // - order info
      if order.isBuffet {
        // number of people
        return Bill.sharedInstance.customers?
      }
    case 2: // - bill info
      // + 1.bill date time
      // + 2.subtotal
      // + 3.tax
      // + 4.total due
      // + 5.discount price (cash discount ...)
      return 5
    case 3: // - service info
      // + 1.Server name
      // + 2.table #
      return 2
    default:
      //order type
      return 1
    }
    
    
    
    return 6
  }
  
  // MARK: BillOutputInterface
  func gotPrice(_ error: NetworkingError?) {
    guard error == nil else {
      self.view?.renderError(error!)
      return
    }
    
    if Bill.sharedInstance.creatPayment() {
      self.view?.renderBill()
    } else {
      self.view?.renderError(.customError(message: "We can not generate your bill, please call for help."))
    }
  }
  
}
