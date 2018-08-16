//
//  OrdersViewController.swift
//  MyOrders
//
//  Created by RBC on 2018-08-13.
//  Copyright © 2018 RBC. All rights reserved.
//

import UIKit

protocol OrdersViewInterface: BaseViewInterface {
  func refreshView()
}

class OrdersViewController: BaseViewController, OrdersViewInterface {
  
  @IBOutlet weak var tableView: UITableView!
  
  private let thisBill = Bill.sharedInstance
  var fulfilled: [String:MenuOrder] {
    return thisBill.order!.items.filter({
      $0.value.status == .fulfilled
    })
  }
  var thisOrder: [String:MenuOrder] {
    return thisBill.order!.items.filter({
      $0.value.status != .fulfilled
    })
  }
  
  
  private var gestureRecognizer:UITapGestureRecognizer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(ReuseIdentifier.orderTableCell.nib, forCellReuseIdentifier: ReuseIdentifier.orderTableCell.rawValue)
    tableView.register(ReuseIdentifier.orderHeaderCell.nib, forHeaderFooterViewReuseIdentifier: ReuseIdentifier.orderHeaderCell.rawValue)
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(tappedAnywhere(_:)))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  override func createPresenter() -> BasePresenter {
    return OrdersPresenter()
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  @IBAction func closeTapped(_ sender: Any) {
    // TODO: update quantity?
    self.dismiss(animated: true, completion: nil)
  }
  
  func refreshView() {
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
      self.dismiss(animated: true) {
        self.view.removeGestureRecognizer(self.gestureRecognizer)
      }
    }
  }
}

// MARK: - Table view data source
extension OrdersViewController: UITableViewDelegate {

}

// MARK: - Table view data source
extension OrdersViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
      // 2 sections - one for current order items, and another one for fulfilled items
    return self.fulfilled.count > 0 ? 2 : 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return self.thisOrder.count
    default:
      return self.fulfilled.count
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let  headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifier.orderHeaderCell.rawValue) as! OrderHeaderCell
    
    switch section {
    case 0:
      headerCell.headerTitle.text = "My orders"
    default:
      headerCell.headerTitle.text = "I liked ..."
    }
      
    return headerCell
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.orderTableCell.rawValue, for: indexPath) as! OrderTableCell

    cell.sequenceNum.text = "\(indexPath.row + 1)"
    switch indexPath.section {
    case 0:
      let index = thisOrder.index(thisOrder.startIndex, offsetBy: indexPath.row)
      cell.thisItem = thisOrder.values[index]
    default:
      let index = fulfilled.index(fulfilled.startIndex, offsetBy: indexPath.row)
      cell.thisItem = fulfilled.values[index]
    }
    cell.delegate = self

    return cell
  }

}
