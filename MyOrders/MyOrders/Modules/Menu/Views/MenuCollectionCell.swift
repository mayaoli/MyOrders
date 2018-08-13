//
//  MenuCollectionCell.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-27.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

class MenuCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var itemImage: UIImageView!
  @IBOutlet weak var itemName: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  
  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  
  
  var menuItem: MenuItem! {
    didSet {
      if menuItem.imageURL != nil {
        itemImage.imageFromUrl(menuItem.imageURL!)
      }
      itemName.text = "\(menuItem.mid) \(menuItem.name)" // + " \(menuItem.shortDescription)"
    }
  }
  
  weak var delegate: UIViewController!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    self.itemImage.roundCorners([.topLeft, .topRight], radius: 10)
    self.roundCorners([.allCorners], radius: 10)
    
    self.addButton.setImage(#imageLiteral(resourceName: "add_grey"), for: UIControlState.highlighted)
    self.removeButton.setImage(#imageLiteral(resourceName: "remove_grey"), for: UIControlState.highlighted)
    
    quantityLabel.text = ""
  }
  
  @IBAction func removeTapped(_ sender: Any) {
    if let q = Int(quantityLabel.text ?? ""), q > 0 {
      (self.delegate as! MenuViewInterface).removeFromOrder(item: menuItem)
      quantityLabel.text = q > 1 ? "\(q - 1)" : ""
    } else {
      quantityLabel.text = ""
    }
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
  }

  @IBAction func addTapped(_ sender: Any) {
    (self.delegate as! MenuViewInterface).addToOrder(item: menuItem)
    if let q = Int(quantityLabel.text ?? "") {
      quantityLabel.text = "\(q + 1)"
    } else {
      quantityLabel.text = "1"
    }
    
    self.doAnimation()
  }
  
  private func doAnimation() {
    
    let offset = self.calculateOffset()
    let screenSize = self.delegate.view.bounds.size
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
    self.delegate.view.drawHierarchy(in: CGRect(x:-offset.x, y:-offset.y, width:screenSize.width, height:screenSize.height), afterScreenUpdates: true)
    let imageView = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
    UIGraphicsEndImageContext()
    
    imageView.frame.origin = offset
    imageView.roundCorners([.allCorners], radius: 10)
    self.delegate.view.addSubview(imageView)
    
    let eps: CGFloat = 1e-5
    let scaledAndTranslatedTransform = imageView.transform.translatedBy(x: screenSize.width - offset.x - 140, y: -offset.y - 10).scaledBy(x: eps, y: eps)
    
    UIView.animate(withDuration: Constants.ANIMATION_DURATION,
                   animations: {
                    imageView.transform = scaledAndTranslatedTransform
    }) { _ in
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
      
      imageView.removeFromSuperview()
      
      let stickyButton = UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyButton.rawValue)
      UIView.animate(withDuration: Constants.ANIMATION_DURATION/2,
                     animations: {
                      stickyButton?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      }) { _ in
        UIView.animate(withDuration: Constants.ANIMATION_DURATION/2,
                       animations: {
                        stickyButton?.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
      }
    }
  }
  
}
