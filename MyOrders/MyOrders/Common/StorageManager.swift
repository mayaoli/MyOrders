//
//  StorageManager.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-23.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation

// Could use other mechanism, like Core Data, SqlLite, event NSUserDefaults (small)
class StorageManager {
  class private func documentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths[0] as String
    return documentDirectory as NSString
  }
  
  class func setObject(arrayToSave: NSArray, path: String) {
    let file = documentsDirectory().appendingPathComponent(path)
    NSKeyedArchiver.archiveRootObject(arrayToSave, toFile: file)
  }
  
  class func getObject(path: String) -> NSArray? {
    let file = documentsDirectory().appendingPathComponent(path)
    let result = NSKeyedUnarchiver.unarchiveObject(withFile: file)
    return result as? NSArray
  }
}
