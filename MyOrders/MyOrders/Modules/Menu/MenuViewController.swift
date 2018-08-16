//
//  MenuViewController.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-27.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

protocol MenuViewInterface: BaseViewInterface {
  func renderMenuList(_ menuList: [Menu])
  
  func addToOrder(item: MenuItem)
  func removeFromOrder(item: MenuItem)
}

class MenuViewController: BaseViewController, MenuViewInterface {

  var menuCategories: [Menu]!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private weak var eventHandler: MenuEventsInterface? {
    return baseEventHandler as? MenuEventsInterface
  }
  
  private let thisBill = Bill.sharedInstance
  private var thisItem: MenuItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    //self.showBackButton = false
    
    self.eventHandler?.getMenuList()
    
    self.title = "Menu"
    collectionView.register(ReuseIdentifier.menuCollectionCell.nib, forCellWithReuseIdentifier: ReuseIdentifier.menuCollectionCell.rawValue)
    collectionView.register(ReuseIdentifier.sectionHeader.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.sectionHeader.rawValue)
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.sectionHeadersPinToVisibleBounds = true
    }
  }
  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    
//    self.collectionView.reloadData()
//  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyButton.rawValue) == nil {
      let stickyButton = UIButton(type: UIButtonType.custom)
      stickyButton.setImage(#imageLiteral(resourceName: "order"), for: UIControlState.normal)
      stickyButton.frame = CGRect(x: self.view.frame.size.width - 80, y: 120, width: 50.0, height: 50.0)
      stickyButton.layer.cornerRadius = 25.0
      stickyButton.layer.borderWidth = 3.0
      stickyButton.layer.borderColor = UIColor.white.cgColor
      stickyButton.shadow(radius: 25.0, strength: 2.0)
      stickyButton.tag = ViewTags.StickyButton.rawValue
      
      stickyButton.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
      UIApplication.shared.keyWindow!.addSubview(stickyButton)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyButton.rawValue)?.removeFromSuperview()
  }
  
  override func createPresenter() -> BasePresenter {
    return MenuPresenter()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case ReuseIdentifier.toLargeView.rawValue?:
      guard let destVC = segue.destination as? MenuImageViewController else {
        break
      }
      destVC.menuItem = thisItem
    case ReuseIdentifier.toOrders.rawValue?:
      guard let _ = segue.destination as? OrdersViewController else {
        break
      }
    default:
      break
    }
  }
  
  // MARK: - MenuViewInterface
  func renderMenuList(_ menuList: [Menu]) {
    menuCategories = menuList
    collectionView.delegate = self
    collectionView.dataSource = self
    self.collectionView.reloadData()
  }
  
  func addToOrder(item: MenuItem) {
    if thisBill.order == nil {
      thisBill.order = Order()
    }
      
    if thisBill.order!.items[item.mid] == nil {
      thisBill.order!.items[item.mid] = MenuOrder(item: item)
    } else {
      thisBill.order!.items[item.mid]?.quantity += 1
    }
  }
  
  func removeFromOrder(item: MenuItem) {
    guard thisBill.order != nil else {
      return
    }
    
    if thisBill.order!.items[item.mid] != nil, thisBill.order!.items[item.mid]!.quantity > 1 {
      thisBill.order!.items[item.mid]!.quantity -= 1
    } else {
      thisBill.order!.items.removeValue(forKey: item.mid)
    }
  }
  
  @objc func buttonTapped() {
    if thisBill.order != nil && thisBill.order!.items.count > 0 {
      self.performSegue(withIdentifier: ReuseIdentifier.toOrders.rawValue, sender: nil)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension MenuViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return menuCategories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIdentifier.sectionHeader.rawValue, for: indexPath) as? SectionHeader{
      sectionHeader.sectionHeaderLabel.text = menuCategories[indexPath.section].categoryName
      return sectionHeader
    }
    return UICollectionReusableView()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return menuCategories[section].menuItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell: MenuCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.menuCollectionCell.rawValue, for: indexPath) as! MenuCollectionCell
    
    let menu: Menu = self.menuCategories[indexPath.section]
    cell.menuItem = menu.menuItems[indexPath.row]
    cell.delegate = self
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.size.width/3, height: 70)
  }
}


// MARK: - UICollectionViewDelegate
extension MenuViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    thisItem = self.menuCategories[indexPath.section].menuItems[indexPath.row]
    self.performSegue(withIdentifier: ReuseIdentifier.toLargeView.rawValue, sender: nil)
    collectionView.deselectItem(at: indexPath, animated: true)
    
    /// - the other way to present model view -
//    guard let largeView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ReuseIdentifier.largeImageView.rawValue) as? MenuImageViewController else {
//      collectionView.deselectItem(at: indexPath, animated: true)
//      return
//    }
//
//    self.present(largeView, animated: true) { () -> Void in
//      largeView.menuItem = self.menuCategories[indexPath.section].menuItems[indexPath.row]
//      collectionView.deselectItem(at: indexPath, animated: true)
//    }
 
  }

 
}
