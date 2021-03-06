//
//  MenuImageViewController.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-08-01.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class MenuImageViewController: UIViewController {
  
  @IBOutlet weak var largeImage: UIImageView!
  @IBOutlet weak var itemName: UILabel!
  @IBOutlet weak var itemDescription: UILabel!
  
  var menuItem: MenuItem!
  
  private var gestureRecognizer:UITapGestureRecognizer!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if menuItem.imageURL != nil {
      self.largeImage.imageFromUrl(menuItem.imageURL!)
    } else {
      self.largeImage.image = #imageLiteral(resourceName: "no-image")
    }
    
    itemName.text = "[\(menuItem.mid.uppercased())] \(menuItem.name)"
    itemDescription.text = menuItem.shortDescription
  
    // Do any additional setup after loading the view.
    gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(tappedAnywhere(_:)))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
  }

  override func viewDidLayoutSubviews() {
    largeImage.addDashedBorder(offsetX: 0, offsetY: 20.0)
    largeImage.roundCorners([.topRight, .topLeft], radius: 20.0)
    //largeImage.shadow(radius: 5.0, strength: 10.0)
    
    super.viewDidLayoutSubviews()
  }
}

// MARK: UIGestureRecognizerDelegate
extension MenuImageViewController: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
  
  @objc private func tappedAnywhere(_ tap: UITapGestureRecognizer) {
    if tap.state == .ended {
      view.endEditing(true)
      self.dismiss(animated: true) {
        self.view.removeGestureRecognizer(self.gestureRecognizer)
        UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyOrderButton.rawValue)?.isHidden = false
        UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyBillButton.rawValue)?.isHidden = false
      }
    }
  }
}
