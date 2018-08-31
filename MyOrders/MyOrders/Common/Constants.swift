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
  static let BASE_URL = "https://www.google.ca"
  static let STORAGE_MENU_PATH: String = "MENU"
  static let STORAGE_ORDER_PATH: String = "ORDER"
  static let STORAGE_PRICE_PATH: String = "PRICE"
  static let ANIMATION_DURATION: TimeInterval = 0.6
  // DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
  static let DISPATCH_DELAY = DispatchTime.now() + 0.1
}

enum ViewTags: Int {
  case TextFieldView = 1
  case StickyOrderButton = 2
  case StickyBillButton = 3
}

enum ReuseIdentifier: String {
  case menuCollectionCell
  case sectionHeader
  case largeImageView
  case orderTableCell
  case orderHeaderCell
  
  case toEatIn
  case toMenu
  case toLargeView
  case toOrders
  case toBill
  
  var nib:UINib? {
    switch self {
    case .menuCollectionCell:
      return UINib(nibName: "MenuCollectionCell", bundle: nil)
    case .sectionHeader:
      return UINib(nibName: "SectionHeader", bundle: nil)
    case .orderTableCell:
      return UINib(nibName: "OrderTableCell", bundle: nil)
    case .orderHeaderCell:
      return UINib(nibName: "OrderHeaderCell", bundle: nil)
    default:
      return nil
    }
    
  }
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
  /// custom error message
  case customError(message: String)
  
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
    case .customError(let message):
      print(message)
      return message
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

enum OrderStatus: String {
  case pending = "Pending Submit"
  case new = "New Order"
  case processing = "Processing"
  case ready = "Ready / Wait for deliver"
  case fulfilled = "Fulfilled / Completed"
}

enum OrderType: String {
    case all = "All"
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
  case IsPositiveNumber = 8 // 1~99
  case IsEmail = 16
  case IsPhoneNumber = 32
  case IsPostcode = 64
  case IsDate = 128
  
  var regex: String {
    switch self {
    case .IsRequired:
      return "^[\\s\\S]+$"
    case .IsAlphabet:
      return "^(A-Za-z)*$"
    case .IsNumeric:
      return "^\\d*$"
    case .IsPositiveNumber:
      return "^[1-9][0-9]?$"
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
      return "must be numeric"
    case .IsPositiveNumber:
      return "must be an number between 1 and 99"
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



