//
//  BillViewController.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-17.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

protocol BillViewInterface: BaseViewInterface {
  func renderBill()
}

class BillViewController: BaseViewController, BillViewInterface {
  
  @IBOutlet weak var tableView: UITableView!
  
  private weak var eventHandler: BillEventsInterface? {
    return baseEventHandler as? BillEventsInterface
  }
  
  private let thisBill = Bill.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "My Bill"
    // Do any additional setup after loading the view.
    
    self.eventHandler?.getPrice()
    
    tableView.register(ReuseIdentifier.baseHeaderCell.nib, forHeaderFooterViewReuseIdentifier: ReuseIdentifier.baseHeaderCell.rawValue)
  }
  
  override func createPresenter() -> BasePresenter {
    return BillPresenter()
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  func renderBill() {
    self.tableView.reloadData()
  }
  
  @IBAction func closeTapped(_ sender: Any) {
    let controllers = self.navigationController?.viewControllers
    for vc in controllers! {
      if vc is MenuViewController {
        _ = self.navigationController?.popToViewController(vc, animated: true)
      }
    }
  }
  
  @IBAction func emailTapped(_ sender: Any) {
    
  }
  
  @IBAction func payTapped(_ sender: Any) {
    // PIN?
    self.renderMessage(title: "Confirm", message: "Have you reviewed all the details and wish to pay now?") { action in
      if action.style == .default {
        // Clear all the information and pop to root
        Bill.sharedInstance.reset()
        self.navigationController?.popToRootViewController(animated: true)
      }
    }
  }
}

// MARK: - Table view data source
extension BillViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.eventHandler?.getRowNumber(section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? 60 : 0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section == 0 else {
      return nil
    }
    
    let  headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifier.baseHeaderCell.rawValue) as! BaseHeaderCell
    
    headerCell.headerTitle.text = self.eventHandler?.getSectionTitle(section) ?? ""
    
    return headerCell
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.billTableCell.rawValue, for: indexPath) 
    
    cell.textLabel?.text = self.eventHandler?.getRowContent(indexPath)
    cell.detailTextLabel?.text = self.eventHandler?.getRowContentDetail(indexPath)
    
    if indexPath.section == 0 || (indexPath.section == 2 && (indexPath.row >= 2 && indexPath.row <= (Bill.sharedInstance.payment?.paymentMethod == .cash ? 3 : 2))) {
      cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 23.0)
      cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 23.0)
    } else {
      cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
      cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17.0)
    }
    
    return cell
  }
}

// MARK: - Table view data source
extension BillViewController: UITableViewDelegate {
  // required for section header
}
