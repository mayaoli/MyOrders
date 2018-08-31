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
  
  class func setObject(objToSave: Any, path: String) {
    let file = documentsDirectory().appendingPathComponent(path)
    NSKeyedArchiver.archiveRootObject(objToSave, toFile: file)
  }
  
  class func getObject(path: String) -> Any? {
    let file = documentsDirectory().appendingPathComponent(path)
    let result = NSKeyedUnarchiver.unarchiveObject(withFile: file)
    return result
  }
  
  class func deleteObject(path: String) -> Bool {
    // TODO: file should be removed
    let file = documentsDirectory().appendingPathComponent(path)
    return NSKeyedArchiver.archiveRootObject(NSNull.self, toFile: file)
  }
}
