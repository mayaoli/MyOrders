//
//  BillInteractor.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-30.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation


// For access the entities in interactor
protocol BillInteractorInput: BaseInputInterface {
  func retrievePrice()
}

class BillInteractor: BaseInteractor, BillInteractorInput {
  
  private weak var output: BillOutputInterface? {
    return baseOutput as? BillOutputInterface
  }
  
  func retrievePrice() {
    let service = ConfigServices()
    
    _ = service.getPriceMatrix { price, error in
      self.output?.gotPrice(price, error)
    }
  }
  
}
