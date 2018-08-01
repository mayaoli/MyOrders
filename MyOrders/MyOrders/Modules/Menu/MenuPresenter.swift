//
//  MenuPresenter.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-27.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

protocol MenuEventsInterface: BaseEventsInterface {
  func getMenuList()
}

protocol MenuOutputInterface: BaseOutputInterface {
  func gotMenuList(_ menuList: [Menu]?, _ error: NetworkingError?)
}

class MenuPresenter: BasePresenter, MenuEventsInterface, MenuOutputInterface {

  private weak var view: MenuViewInterface? {
    return baseView as? MenuViewInterface
  }
  private weak var interactor: MenuInteractorInput? {
    return baseInteractor as? MenuInteractorInput
  }
  
  override func createInteractor() -> BaseInteractor {
    return MenuInteractor()
  }
  
  // MARK: MenuEventsInterface
  func getMenuList() {
    self.interactor?.retrieveMenuList()
  }
  
  // MARK: MenuOutputInterface
  func gotMenuList(_ menuList: [Menu]?, _ error: NetworkingError?) {
    guard error == nil else {
      self.view?.renderError(error!)
      return
    }
    
    self.view?.renderMenuList(menuList!)
  }
  
}
