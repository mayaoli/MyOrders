//
//  PINService.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-11-28.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

class PINServices: BaseServices {
  
  func ValidatePIN (_ pinText: String, completion: @escaping (_ valid: Bool, _ error: NetworkingError?) -> Void) -> URLSessionTask? {
    let urlString = "\(Constants.BASE_URL)/pin"
    
    guard let url = URL(string: urlString) else {
      completion(false, .unknown)
      return nil
    }
    
    let parameters : [String : Any] = ["validate" : pinText]
    
    return post(url: url, bodyParameters: parameters) { (response, data, error) in
      guard error == nil else {
        completion(false, error)
        return
      }
      
      guard data?.type == .json, let json = data?.json else {
        completion(false, .responseValidationFailed(reason: response.debugDescription))
        return
      }
      
      completion(json["result"].stringValue.caseInsensitiveCompare("ok") == .orderedSame, nil)
    }
  }
  
}
