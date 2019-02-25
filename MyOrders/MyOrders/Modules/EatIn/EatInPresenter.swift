//
//  EatInPresenter.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-11-29.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

protocol EatInEventsInterface: BaseEventsInterface {
  func validatePIN(_ pin: String)
}

protocol EatInOutputInterface: BaseOutputInterface {
  func validationCompleted(_ valid: Bool, _ error: NetworkingError?)
}

class EatInPresenter: BasePresenter, EatInEventsInterface, EatInOutputInterface {
  
  private weak var view: EatInViewInterface? {
    return baseView as? EatInViewInterface
  }
  private weak var interactor: EatInInteractorInput? {
    return baseInteractor as? EatInInteractorInput
  }
  
  override func createInteractor() -> BaseInteractor {
    return EatInInteractor()
  }
  
  func validatePIN(_ pin: String) {
    self.view?.disableEnableField()
    self.interactor?.validatePIN(pin)
  }
  
  func validationCompleted(_ valid: Bool, _ error: NetworkingError?) {
    self.view?.disableEnableField()
    guard error == nil else {
      self.view?.renderError(error!)
      return
    }
    
    self.view?.gotoNext()
  }
}
