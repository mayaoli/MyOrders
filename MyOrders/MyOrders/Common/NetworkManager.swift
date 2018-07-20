//
//  NetworkManager.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-24.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
  
  //shared instance
  static let sharedInstance = NetworkManager()
  
  let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
  var reachabilityStatus: NetworkStatus = .reachable
  
  func startNetworkReachabilityObserver() {
    
    reachabilityManager?.listener = { status in
      switch status {
      case .reachable(_), .unknown:
        self.reachabilityStatus = .reachable
      case .notReachable:
        self.reachabilityStatus = .notReachable
      }
    }
    
    // start listening
    reachabilityManager?.startListening()
  }
}
