//
//  MenuInteractor.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-29.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

// For access the entities in interactor
protocol MenuInteractorInput: BaseInputInterface {
  func retrieveMenuList()
}

class MenuInteractor: BaseInteractor, MenuInteractorInput {
  
  private weak var output: MenuOutputInterface? {
    return baseOutput as? MenuOutputInterface
  }
  
  func retrieveMenuList() {
    
    let service = MenuServices()
    
    _ = service.getMenuList { menuList, error in
      
      guard error == nil else {
        self.output?.gotMenuList(nil, error)
        return
      }
      
      self.output?.gotMenuList(menuList, nil)
    }
    
  }
  
  
}
