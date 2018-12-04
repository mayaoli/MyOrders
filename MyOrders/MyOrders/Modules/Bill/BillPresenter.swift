//
//  BillPresenter.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-30.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import Foundation

protocol BillEventsInterface: BaseEventsInterface {
  func getPrice()
  func getRowNumber(_ section: Int) -> Int
  func getRowContent(_ indexPath: IndexPath) -> String
  func getRowContentDetail(_ indexPath: IndexPath) -> String
}

protocol BillOutputInterface: BaseOutputInterface {
  func gotPrice(_ error: NetworkingError?)
}

class BillPresenter: BasePresenter, BillEventsInterface, BillOutputInterface {
  
  private weak var view: BillViewInterface? {
    return baseView as? BillViewInterface
  }
  private weak var interactor: BillInteractorInput? {
    return baseInteractor as? BillInteractorInput
  }
  
  override func createInteractor() -> BaseInteractor {
    return BillInteractor()
  }
  
  // MARK: BillEventsInterface
  func getPrice() {
    if Price.sharedInstance.lunch == nil || Price.sharedInstance.dinner == nil {
      self.interactor?.retrievePrice()
    } else {
      self.gotPrice(nil)
    }
  }
  
  func getRowNumber(_ section: Int) -> Int {
    guard let order = Bill.sharedInstance.order else {
      return 0
    }
    guard let cst = Bill.sharedInstance.customers, cst.count > 0, cst[0].priceRange != .none else {
      return 0
    }
    
    switch section {
    case 0:
      // order type
      // restaurant name
      // address line 1 + Address line 2
      // phone number
      // website
      // bill date time
      return 1
    case 1: // - order info
      if order.isBuffet {
        // number of people + number of by order items
        return Bill.sharedInstance.customers!.count + (Bill.sharedInstance.order?.items.filter{ $0.1.orderAvailability == .eatInByOrder }.count ?? 0)
      }
    case 2: // - bill info
      // + 1.subtotal
      // + 2.tax
      // + 3.total due
      // + 4.discount price (cash discount ...)
      return 4
    case 3: // - service info
      // + 1.Server name
      // + 2.table #
      return 2
    default:
      return 0
    }
    
    return 0
  }
  
  func getRowContent(_ indexPath: IndexPath) -> String {

    var text: String = ""
    
    switch indexPath.section {
    case 0:
      let restaurantInfo = Price.sharedInstance.restaurant
        
      // Order type
      switch indexPath.row {
      case 0:
        text = Bill.sharedInstance.order?.orderType.rawValue ?? ""
      case 1:
        text = restaurantInfo?.name ?? ""
      case 2:
        text = "\(restaurantInfo?.address1 ?? "") \(restaurantInfo?.address2 ?? "")"
      case 3:
        text = restaurantInfo?.phone ?? ""
      case 4:
        text = restaurantInfo?.website ?? ""
      default:
        break
      }
    case 1:
      // Order info
      if let des = Bill.sharedInstance.customers?[indexPath.row].priceRange.description {
        text = des
      }
    case 2:
      // Bill info
      switch indexPath.row {
      case 0:
        text = "Subtitle"
      case 1:
        text = "Tax"
      case 2:
        text = "Total due"
      case 3:
        text = "Discount price"
      default:
        break
      }
    default:
      break
    }
    
    return text
  }
  
  func getRowContentDetail(_ indexPath: IndexPath) -> String {
    guard Price.sharedInstance.restaurant != nil, let order = Bill.sharedInstance.order else {
      return ""
    }
    guard let cust = Bill.sharedInstance.customers, indexPath.row < cust.count else {
      return ""
    }
    
    var detail : String = ""
    switch indexPath.section {
    case 1:
      // Order info
      switch order.orderType {
      case .lunchBuffet, .dinnerBuffet:
        detail = "$\(Price.getAmount(order.orderType, Bill.sharedInstance.customers![indexPath.row].priceRange.age))"
      default:
        break
      }
    case 2:
      // Bill info
      switch indexPath.row {
      case 0:
        detail = "$\(Bill.sharedInstance.payment?.rawAmount ?? 0)"
      case 1:
        detail = "$\(Bill.sharedInstance.payment?.tax ?? 0)"
      case 2:
        detail = "$\(Bill.sharedInstance.payment?.totalAmount ?? 0)"
      case 3:
        detail = "$\(Bill.sharedInstance.payment?.cashAmount ?? 0)"
      default:
        break
      }
      
    default:
      break
    }
    
    return detail
  }
  
  // MARK: BillOutputInterface
  func gotPrice(_ error: NetworkingError?) {
    guard error == nil else {
      self.view?.renderError(error!)
      return
    }
    
    if Bill.sharedInstance.creatPayment() {
      self.view?.renderBill()
    } else {
      self.view?.renderError(.customError(message: "We can not generate your bill, please call for help."))
    }
  }
  
}
