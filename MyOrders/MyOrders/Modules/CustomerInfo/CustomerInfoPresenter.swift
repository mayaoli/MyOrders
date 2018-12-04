//
//  CustomerInfoPresenter.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-10-31.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation


protocol CustomerEventsInterface: BaseEventsInterface {
  func getRowNumber(_ section: Int) -> Int?
  func getSectionTitle(_ section: Int) -> String?
  func getPriceRange(_ index: UInt) -> PriceRange
  func removeCustomer(_ idx: Int)
  func validatePIN(_ pin: String)
}

protocol CustomerInfoOutputInterface: BaseOutputInterface {
  func validationCompleted(_ valid: Bool, _ error: NetworkingError?)
}

class CustomerInfoPresenter: BasePresenter, CustomerEventsInterface, CustomerInfoOutputInterface {
  
  private weak var view: CustomerInfoViewInterface? {
    return baseView as? CustomerInfoViewInterface
  }
  private weak var interactor: CustomerInfoInteractorInput? {
    return baseInteractor as? CustomerInfoInteractorInput
  }
  
  override func createInteractor() -> BaseInteractor {
    return CustomerInfoInteractor()
  }
  
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
  
  func removeCustomer(_ idx: Int) {
    guard let theCustomers = Bill.sharedInstance.customers, idx < theCustomers.count else {
      return
    }
    
    Bill.sharedInstance.customers!.remove(at: idx)
    self.view?.refreshView()
  }
  
  func validatePIN(_ pin: String) {
    self.interactor?.validatePIN(pin)
  }
  
  func validationCompleted(_ valid: Bool, _ error: NetworkingError?) {
    guard error == nil else {
      self.view?.renderError(error!)
      return
    }
    
    self.view?.renderCustomerInfo()
  }
  
  
  func getSectionTitle(_ section: Int) -> String? {
    return "Edit Customer Info"
  }
}
