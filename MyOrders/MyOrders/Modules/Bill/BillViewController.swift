//
//  BillViewController.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-17.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

protocol BillViewInterface: BaseViewInterface {
  func renderBill(_ price: Price)
}

class BillViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Bill"
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
