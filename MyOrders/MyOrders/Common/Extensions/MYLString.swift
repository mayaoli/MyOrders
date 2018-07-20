//
//  MYLString.swift
//  MyOrders
//
//  Created by RBC on 2018-07-19.
//  Copyright © 2018 RBC. All rights reserved.
//

import Foundation

extension String {
  func getSubstring(fromIndex: String.Index, to: Int) -> String {
    let range = fromIndex..<self.index(fromIndex, offsetBy: to)
    return String(self[range])
  }
  
  func getSubstringFromIndices(fromIndex: String.Index, toIndex: String.Index) -> String {
    let range = fromIndex..<toIndex
    return String(self[range])
  }
}
