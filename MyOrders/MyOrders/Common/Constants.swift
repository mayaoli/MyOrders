//
//  Constants.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation
import SwiftyJSON
import SWXMLHash

struct Constants {
  static let BUNDLE_NUMBER = 10
  static let BASE_URL = "https://www.google.ca" //"https://fancycars.ca"
  static let STORAGE_PATH: String = "CachedObject"
}

enum SegueIdentifier: String {
  case toEatIn
}

// For a single view application, there is really no need to define so many enums.
// However, here is to show how the project should be structured

enum NetworkingError: Error {
  
  // MARK: Error Cases
  
  /// Unknown of generic error
  case unknown
  /// If no internet is detected
  case noInternet
  /// Request validation failed when making a network call.
  case requestValidationFailed
  /// Response validation failed after making a network call.
  case responseValidationFailed
  /// Request or Response encoding failed
  case encodingFailed
  
  
  var debugDescription: String {
    switch self {
    case .unknown:
      return "An unknown error has occurred."
    case .noInternet:
      return "No Internet connectivity. Reason: Check your network or Service not reachable."
    case .requestValidationFailed:
      print("Request validation failed. Reason: Invalid URL, incorrect request parameters, headers, http method, etc.")
      return "Technical issue"
    case .responseValidationFailed:
      print("Response validatation failed. Reason: Data file nil, missing or unacceptable ContentType, serialization failed or unacceptable status code.")
      return "Technical issue"
    case .encodingFailed:
      print("Parameter or Multi-part encoding failed. Reason: Missing URL, json/plist encoding failed, stream read/write failed, etc.")
      return "Technical issue"
    }
  }
}

enum ContentType {
  case json
  case form
}

enum Method: String {
  case GET
  case POST
}

enum NetworkStatus {
  case reachable
  case notReachable
  case unknown
}

enum FoodStatus: String {
    case new = "New Order"
    case processing = "Processing"
    case ready = "Ready / Wait for deliver"
    case fulfilled = "Fulfilled / Completed"
}

enum OrderType: String {
    case delivery = "Delivery"
    case pickupOrTakeout = "Pick Up / Take out"
    case eatin = "Eat In"
}

enum PaymentMethod: String {
    case cash = "Cash"
    case debit = "Debit Card"
    case credit = "Credit Card"
    case other = "Other" // like paypal
}

enum TableViewCellReuseIdentifier: String {
  case CarListCell
}

enum FieldState {
  case normal
  case focus
  case error(message: String)
}

enum ValidationType: UInt {
  case None = 0
  case IsRequired = 1
  case IsAlphabet = 2
  case IsNumeric = 4
  case IsEmail = 8
  case IsPhoneNumber = 16
  case IsPostcode = 32
  case IsDate = 64
  
  var regex: String {
    switch self {
    case .IsRequired:
      return "^[\\s\\S]+$"
    case .IsAlphabet:
      return "^(A-Za-z)*$"
    case .IsNumeric:
      return "^\\d*$"
    case .IsEmail:
      return "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)|([0-9a-zA-Z]+\\.))+[a-zA-Z]{2,9})$"
    case .IsPhoneNumber:
      return "^((\\d?(-| |)\\d{3}(-| )\\d{3}(-| )\\d{4})|(\\d{10,11})|(\\d?(-| |)\\(\\d{3}\\)(-| |)\\d{3}(-| |)\\d{4}))( |)(ext|x|ext\\:|x:| )?\\d{0,5}$"
    case .IsPostcode:
      return "^(\\d{5}-\\d{4}|\\d{5})$|^([a-zA-Z]\\d[a-zA-Z][\\s-]?\\d[a-zA-Z]\\d)$"
    case .IsDate:
      return "^(\\d){2}/(\\d){2}/(\\d){4}$"  // dd/mm/yyyy
    default:
      return ""
    }
  }
  
  var error: String {
    switch self {
    case .IsRequired:
      return "is required"
    case .IsAlphabet:
      return "must be an alphabet value"
    case .IsNumeric:
      return "must be an number"
    case .IsEmail:
      return "must be a valid Email address"
    case .IsPhoneNumber:
      return "must be a valid phone number"
    case .IsPostcode:
      return "must be a valid postcode"
    case .IsDate:
      return "must be a valid date"
    default:
      return "No error."
    }
  }
}

struct NetworkErrorInformation {
  
  let httpStatusCode: Int
  let statusCodes: [String]
  
  init?(json: JSON) {
    
    let statusInformation = json["status"].dictionaryValue
    
    guard let httpStatusCode = statusInformation["httpStatusCode"]?.int else {
      return nil
    }
    
    guard let statusCodes = statusInformation["details"]?.array, !statusCodes.isEmpty else {
      return nil
    }
    
    let codes = statusCodes.compactMap { $0["statusCode"].string }
    
    self.httpStatusCode = httpStatusCode
    self.statusCodes = codes
    
  }
  
  init?(httpURLResponse: HTTPURLResponse, error: Error){
    httpStatusCode = httpURLResponse.statusCode
    statusCodes = [String((error as NSError).code)]
  }
  
  init?(error: Error){
    httpStatusCode = 0
    statusCodes = [String((error as NSError).code)]
  }
  
  init?(error: NetworkingError){
    httpStatusCode = 0
    statusCodes = [String((error as NSError).code)]
  }
}

struct ResponseData {
  enum DataType {
    case json
    case xml
    case string
  }
  
  var type: DataType
  var json: JSON?
  var xml: XMLIndexer?
  var string: String?
}



