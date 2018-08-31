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
}

protocol BillOutputInterface: BaseOutputInterface {
  func gotPrice(_ price: Price?, _ error: NetworkingError?)
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
    self.interactor?.retrievePrice()
  }
  
  // MARK: BillOutputInterface
  func gotPrice(_ price: Price?, _ error: NetworkingError?) {
    guard error == nil else {
      self.view?.renderError(error!)
      return
    }
    
    //self.view?.renderBillList(BillList ?? [])
  }
  
}
