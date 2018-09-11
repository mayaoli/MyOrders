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
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - Table view data source
extension BillViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.eventHandler?.getRowNumber(section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.billTableCell.rawValue, for: indexPath) 
    
    switch indexPath.section {
    case 0:
      // Order type
      cell.textLabel?.text = thisBill.order?.orderType.rawValue
    case 1:
      // Order info
      switch (thisBill.order!.orderType) {
      case .lunchBuffet, .dinnerBuffet:
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
      default:
        cell.textLabel?.text = ""
      }
    default:
      cell.textLabel?.text = ""
    }
    
    return cell
  }
}
