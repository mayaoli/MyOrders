//
//  CustomerInfoInteractor.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-11-28.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

// For access the entities in interactor
protocol CustomerInfoInteractorInput: BaseInputInterface {
  func validatePIN(_ pin: String)
}

class CustomerInfoInteractor: BaseInteractor, CustomerInfoInteractorInput {
  
  private weak var output: CustomerInfoOutputInterface? {
    return baseOutput as? CustomerInfoOutputInterface
  }
  
  func validatePIN(_ pin: String) {
    let service = PINServices()
    
    _ = service.ValidatePIN(pin) { valid, error in
      self.output?.validationCompleted(valid, error)
    }
  }
  
}
