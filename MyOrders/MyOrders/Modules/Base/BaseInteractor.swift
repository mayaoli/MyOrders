//
//  BaseInteractor.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-24.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation

// For access the entities in interactor
protocol BaseInputInterface: class {
  
}

class BaseInteractor: NSObject {

  weak var baseOutput: BaseOutputInterface?
  
  override init() {
    super.init()
  }
  
}
