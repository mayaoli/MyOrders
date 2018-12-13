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
  func getSectionTitle(_ section: Int) -> String?
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
      // + 5.tip suggestions
      return 5
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
    guard Price.sharedInstance.restaurant != nil, let order = Bill.sharedInstance.order, let customers = Bill.sharedInstance.customers else {
      return ""
    }
    
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
      if indexPath.row < customers.count {
        text = customers[indexPath.row].priceRange.description
      } else if let byOrder = (Bill.sharedInstance.order?.items.filter{ $0.1.orderAvailability == .eatInByOrder })?.map({ (key, value) in (value) })  {
        let curIdx = indexPath.row - customers.count
        if curIdx < byOrder.count {
          text = "\(byOrder[curIdx].name) [Qty:\(byOrder[curIdx].quantity)]"
        }
      }
    case 2:
      // Bill info
      switch indexPath.row {
      case 0:
        text = "    Subtotal"
      case 1:
        text = "    Tax [HST \(Constants.TAX_RATE*100)%]"
      case 2:
        text = "Total Due"
      case 3:
        text = "Cash Payment"
      case 4:
        text = "Tip Rate"
      default:
        break
      }
    default:
      break
    }
    
    return text
  }
  
  func getRowContentDetail(_ indexPath: IndexPath) -> String {
    guard Price.sharedInstance.restaurant != nil, let order = Bill.sharedInstance.order, let customers = Bill.sharedInstance.customers else {
      return ""
    }
    
    var detail : String = ""
    switch indexPath.section {
    case 1:
      // Order info
      switch order.orderType {
      case .lunchBuffet, .dinnerBuffet:
        if indexPath.row < customers.count {
          detail = Price.getAmount(order.orderType, customers[indexPath.row].priceRange.age).toCurrency()
        } else if let byOrder = (Bill.sharedInstance.order?.items.filter{ $0.1.orderAvailability == .eatInByOrder })?.map({ (key, value) in (value) })  {
          let curIdx = indexPath.row - customers.count
          if curIdx < byOrder.count {
            detail = ((byOrder[curIdx].price ?? 0) * Double(byOrder[curIdx].quantity)).toCurrency()
          }
        }
      default:
        break
      }
    case 2:
      // Bill info
      if let pay = Bill.sharedInstance.payment {
        switch indexPath.row {
        case 0:
          detail = pay.rawAmount.toCurrency()
        case 1:
          detail = pay.tax.toCurrency()
        case 2:
          detail = pay.totalAmount.toCurrency()
        case 3:
          detail = pay.cashAmount.toCurrency()
        case 4:
          detail = String(format: "10%% = $%.2f | 15%% = $%.2f | 20%% = $%.2f", pay.tip10percent, pay.tip15percent, pay.tip20percent)
        default:
          break
        }
      } else {
        detail = "$---"
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
  
  func getSectionTitle(_ section: Int) -> String? {
    return "Your Receipt"
  }
}
