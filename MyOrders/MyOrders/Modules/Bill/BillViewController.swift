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
    
    cell.textLabel?.text = self.eventHandler?.getRowContent(indexPath)
    cell.detailTextLabel?.text = self.eventHandler?.getRowContentDetail(indexPath)
    
    return cell
  }
}
