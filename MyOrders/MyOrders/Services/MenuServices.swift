//
//  CarServices.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation

class MenuServices: BaseServices {
  
  func getMenuList(completion: @escaping (_ menu: [Menu]?, _ error: NetworkingError?) -> Void) -> URLSessionTask? {
    
    let urlString = "\(Constants.BASE_URL)/menu"
    
    guard let url = URL(string: urlString) else {
      completion([], .unknown)
      return nil
    }
    
    return get(url: url) { (response, data, error) in
      
      var menu: [Menu]? = StorageManager.getObject(path: Constants.STORAGE_MENU_PATH) as? [Menu]
      
      guard error == nil else {
        completion(menu, error)
        return
      }
      
      guard data?.type == .json, let json = data?.json else {
        completion(menu, .responseValidationFailed)
        return
      }
      
      do {
        menu = try UtilityManager.getArray(json, type: Menu.self)
      } catch {}
     
      if menu != nil, menu!.count > 0 {
        StorageManager.setObject(objToSave: menu!, path: Constants.STORAGE_MENU_PATH)
      } else {
        // this shall not happen
        menu = StorageManager.getObject(path: Constants.STORAGE_MENU_PATH) as? [Menu]
      }
      
      completion(menu, nil)
    }
  }

  func syncMenu(_ menu: [Menu], completion: @escaping (_ error: NetworkingError?) -> Void) -> URLSessionTask? {
    let urlString = "\(Constants.BASE_URL)/SyncMenu"
    
    guard let url = URL(string: urlString), !menu.isEmpty else {
      completion(.unknown)
      return nil
    }
    
    var parameters : [String : Any] = [:]
    
    for cat in menu {
      for item in cat.menuItems {
        parameters["\(item.mid)"] = item.payload
      }
    }
    
    return post(url: url, bodyParameters: parameters) { (response, data, error) in
      guard error == nil else {
        completion(error)
      return
    }
      
      guard data?.type == .json, let _ = data?.json else {
        completion(.responseValidationFailed)
        return
      }
        
        // TODO: check response ok
        //json["result"] == "ok"
      
      completion(nil)
    }
  }
    
}
