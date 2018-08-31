//
//  ConfigServices.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-30.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

class ConfigServices: BaseServices {

  func getPriceMatrix(completion: @escaping (_ price: Price?, _ error: NetworkingError?) -> Void) -> URLSessionTask? {
    let urlString = "\(Constants.BASE_URL)/price"
    
    guard let url = URL(string: urlString) else {
      completion(nil, .unknown)
      return nil
    }
    
    return get(url: url) { (response, data, error) in
      
      var price: Price? = StorageManager.getObject(path: Constants.STORAGE_PRICE_PATH) as? Price
      
      guard error == nil else {
        completion(price, error)
        return
      }
      
      guard data?.type == .json, let json = data?.json else {
        completion(price, .responseValidationFailed)
        return
      }
      
      do {
        price = try Price(json: json)
      } catch {}
      
      if price != nil {
        StorageManager.setObject(objToSave: price!, path: Constants.STORAGE_PRICE_PATH)
      } else {
        price = StorageManager.getObject(path: Constants.STORAGE_PRICE_PATH) as? Price
      }
      
      completion(price, nil)
    }
  }
  
}
