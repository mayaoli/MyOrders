//
//  MenuImageViewController.swift
//  MyOrders
//
//  Created by RBC on 2018-08-01.
//  Copyright © 2018 RBC. All rights reserved.
//

import UIKit

class MenuImageViewController: UIViewController {
  
  @IBOutlet weak var largeImage: UIImageView!
  @IBOutlet weak var itemName: UILabel!
  @IBOutlet weak var itemDescription: UILabel!
  
  var menuItem: MenuItem! {
    didSet {
      if menuItem.imageURL != nil {
        self.largeImage.imageFromUrl(menuItem.imageURL!)
      } else {
        self.largeImage.image = #imageLiteral(resourceName: "no-image")
      }
      
      itemName.text = "\(menuItem.mid) \(menuItem.name)"
      itemDescription.text = menuItem.shortDescription
    }
  }
  
  private var gestureRecognizer:UITapGestureRecognizer!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(tappedAnywhere(_:)))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
  }

  override func viewDidLayoutSubviews() {
    largeImage.addDashedBorder(offset: 20.0)
    largeImage.roundCorners([.allCorners], radius: 10.0)
    largeImage.shadow(radius: 5.0, strength: 10.0)
    
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
      }
    }
  }
}
