//
//  OrdersViewController.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-13.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

protocol OrdersViewInterface: BaseViewInterface {
  var pending: [MenuOrder] {get}
  var thisOrder: [MenuOrder] {get}
  var fulfilled: [MenuOrder] {get}
  
  func refreshView(_ needRefreshSelf: Bool)
}

class OrdersViewController: BaseViewController, OrdersViewInterface {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var billButton: UIButton!
  
  private var sortedItems = Bill.sharedInstance.order!.items.sorted(by: { $0.0 < $1.0 }).map{ $0.value }
  
  var pending: [MenuOrder] {
    return sortedItems.filter({
      $0.status == .pending
    })
  }
  var thisOrder: [MenuOrder] {
    return sortedItems.filter({
      $0.status != .fulfilled && $0.status != .pending
    })
  }
  var fulfilled: [MenuOrder] {
    return sortedItems.filter({
      $0.status == .fulfilled
    })
  }
  
  private var gestureRecognizer:UITapGestureRecognizer!
  
  private weak var eventHandler: OrdersEventsInterface? {
    return baseEventHandler as? OrdersEventsInterface
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    StorageManager.setObject(objToSave: sortedItems as NSArray, path: Constants.STORAGE_ORDER_PATH)
    
    tableView.register(ReuseIdentifier.orderTableCell.nib, forCellReuseIdentifier: ReuseIdentifier.orderTableCell.rawValue)
    tableView.register(ReuseIdentifier.orderHeaderCell.nib, forHeaderFooterViewReuseIdentifier: ReuseIdentifier.orderHeaderCell.rawValue)
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(tappedAnywhere(_:)))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
    
    submitButton.isEnabled = pending.count > 0
    billButton.isHidden = thisOrder.count + fulfilled.count == 0
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.view.removeGestureRecognizer(self.gestureRecognizer)
    UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyOrderButton.rawValue)?.isHidden = false
    UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyBillButton.rawValue)?.isHidden = false
  }
  
  override func createPresenter() -> BasePresenter {
    return OrdersPresenter()
  }
  
  /*
   // MARK: - Navigation
   
  
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  @IBAction func closeTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func submitTapped(_ sender: Any) {
    ///TODO: call service to send push notification
    
    pending.forEach { (pi) in
      let oldkey = pi.key
      
      if let orderedItem = thisOrder.first(where: { $0.category.caseInsensitiveCompare(pi.category) == .orderedSame && $0.mid.caseInsensitiveCompare(pi.mid) == .orderedSame && $0.status == .new }) {
        orderedItem.quantity += pi.quantity
      } else {
        pi.status = .new
        Bill.sharedInstance.order!.items[pi.key] = pi
      }
      Bill.sharedInstance.order!.items.removeValue(forKey: oldkey)
    }
    StorageManager.setObject(objToSave: sortedItems as NSArray, path: Constants.STORAGE_ORDER_PATH)
    
    self.refreshView(false)
    self.dismiss(animated: true)
  }
  
  @IBAction func billTapped(_ sender: Any) {
    guard pending.count == 0 else {
      DispatchQueue.main.asyncAfter(deadline: Constants.DISPATCH_DELAY, execute: {
        self.renderMessage(title: "Confirm", message: "It seems that there are still some items in pending.\n\n Are you sure, you don't want them?", completion: { action in
          if action.style == .default {
            (UIApplication.shared.windows[0].rootViewController as? UINavigationController)?.topViewController?.performSegue(withIdentifier: ReuseIdentifier.toCustomerInfo.rawValue, sender: nil)
          }
        })
      })
      
      self.dismiss(animated: true)
      return
    }
    
    // call help
    
    // to customerInfo
    self.dismiss(animated: true)
    (UIApplication.shared.windows[0].rootViewController as? UINavigationController)?.topViewController?.performSegue(withIdentifier: ReuseIdentifier.toCustomerInfo.rawValue, sender: nil)
  }
  
  func refreshView(_ needRefreshSelf: Bool) {
    if needRefreshSelf {
      self.sortedItems = Bill.sharedInstance.order!.items.sorted(by: { $0.0 < $1.0 }).map{ $0.value }
      self.eventHandler?.prepareData()
      self.tableView.reloadData()
    }
    
    guard let navCtrl = UIApplication.shared.windows[0].rootViewController as? UINavigationController else {
      return
    }
    guard let menuVC = navCtrl.topViewController as? MenuViewController else {
      return
    }
    menuVC.collectionView.reloadData()
  }
  
}

// MARK: UIGestureRecognizerDelegate
extension OrdersViewController: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
  
  @objc private func tappedAnywhere(_ tap: UITapGestureRecognizer) {
    if tap.state == .ended {
      view.endEditing(true)
      self.dismiss(animated: true) 
    }
  }
}

// MARK: - Table view data source
extension OrdersViewController: UITableViewDelegate {

}

// MARK: - Table view data source
extension OrdersViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.eventHandler?.getSectionNumber() ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.eventHandler?.getRowNumber(section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let  headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifier.orderHeaderCell.rawValue) as! OrderHeaderCell
    
    headerCell.headerTitle.text = self.eventHandler?.getSectionTitle(section) ?? ""
      
    return headerCell
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.orderTableCell.rawValue, for: indexPath) as! OrderTableCell
    cell.sequenceNum.text = "\(indexPath.row + 1)"
    cell.thisItem = self.eventHandler?.getRowItem(indexPath)
    cell.delegate = self

    return cell
  }

}
