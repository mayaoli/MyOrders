//
//  EatInInteractor.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-11-29.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

protocol EatInInteractorInput: BaseInputInterface {
  func validatePIN(_ pin: String)
}

class EatInInteractor: BaseInteractor, EatInInteractorInput {
  
  private weak var output: EatInOutputInterface? {
    return baseOutput as? EatInOutputInterface
  }
  
  func validatePIN(_ pin: String) {
    let service = PINServices()
    
    _ = service.ValidatePIN(pin) { valid, error in
      self.output?.validationCompleted(valid, error)
    }
  }
  
}
