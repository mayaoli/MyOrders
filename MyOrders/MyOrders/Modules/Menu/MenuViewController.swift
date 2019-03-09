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

enum MenuCollectionViews: Int {
  case Menu = 0
  case Category = 1
}

class MenuViewController: BaseViewController, MenuViewInterface {

  var menuCategories: [Menu]!
  
  @IBOutlet weak var menuCollectionView: UICollectionView!
  @IBOutlet weak var menuViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var categoryContainer: UIView!
  @IBOutlet weak var categoryCollectionView: UICollectionView!
  @IBOutlet weak var categoryTopConstraint: NSLayoutConstraint!
  
  private weak var eventHandler: MenuEventsInterface? {
    return baseEventHandler as? MenuEventsInterface
  }
  
  private let thisBill = Bill.sharedInstance
  private var thisItem: MenuItem!
  
  override func viewDidLoad() {
    if thisBill.order!.items.isEmpty {
      if let items = StorageManager.getObject(path: Constants.STORAGE_ORDER_PATH) as? [MenuOrder] {
        thisBill.order?.items =  items.reduce(into: [String:MenuOrder]()) { $0[$1.key]=$1 }
      }
    }
    
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    //self.showBackButton = false
    
    self.eventHandler?.getMenuList()
    
    self.title = "Our Menu"
    menuCollectionView.register(ReuseIdentifier.menuCollectionCell.nib, forCellWithReuseIdentifier: ReuseIdentifier.menuCollectionCell.rawValue)
    menuCollectionView.register(ReuseIdentifier.sectionHeader.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.sectionHeader.rawValue)
    if let layout = menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.sectionHeadersPinToVisibleBounds = true
    }
    
    categoryCollectionView.register(ReuseIdentifier.categoryCollectionCell.nib, forCellWithReuseIdentifier: ReuseIdentifier.categoryCollectionCell.rawValue)
    self.categoryTopConstraint.constant = -130
    
    self.view.setNeedsUpdateConstraints()
    self.view.updateConstraintsIfNeeded()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // catalog
    if UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyBillButton.rawValue) == nil {
      let stickyButton = UIButton(type: UIButtonType.custom)
      stickyButton.setImage(#imageLiteral(resourceName: "catalog"), for: UIControlState.normal)
      stickyButton.frame = CGRect(x: self.view.frame.size.width - 80, y: 100, width: 50.0, height: 50.0)
      stickyButton.layer.cornerRadius = 25.0
      stickyButton.layer.borderWidth = 3.0
      stickyButton.layer.borderColor = UIColor.white.cgColor
      stickyButton.shadow(radius: 25.0, strength: 2.0)
      stickyButton.tag = ViewTags.StickyBillButton.rawValue
      
      stickyButton.addTarget(self, action: #selector(catagoryTapped), for: UIControlEvents.touchUpInside)
      UIApplication.shared.keyWindow!.addSubview(stickyButton)
    }
    
    // orders
    if UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyOrderButton.rawValue) == nil {
      let stickyButton = UIButton(type: UIButtonType.custom)
      stickyButton.setImage(#imageLiteral(resourceName: "order"), for: UIControlState.normal)
      stickyButton.frame = CGRect(x: self.view.frame.size.width - 80, y: 180, width: 50.0, height: 50.0)
      stickyButton.layer.cornerRadius = 25.0
      stickyButton.layer.borderWidth = 3.0
      stickyButton.layer.borderColor = UIColor.white.cgColor
      stickyButton.shadow(radius: 25.0, strength: 2.0)
      stickyButton.tag = ViewTags.StickyOrderButton.rawValue
      
      stickyButton.addTarget(self, action: #selector(orderTapped), for: UIControlEvents.touchUpInside)
      UIApplication.shared.keyWindow!.addSubview(stickyButton)
    }
    
    // bill
    if UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyBillButton.rawValue) == nil {
      let stickyButton = UIButton(type: UIButtonType.custom)
      stickyButton.setImage(#imageLiteral(resourceName: "bill"), for: UIControlState.normal)
      stickyButton.frame = CGRect(x: self.view.frame.size.width - 80, y: 260, width: 50.0, height: 50.0)
      stickyButton.layer.cornerRadius = 25.0
      stickyButton.layer.borderWidth = 3.0
      stickyButton.layer.borderColor = UIColor.white.cgColor
      stickyButton.shadow(radius: 25.0, strength: 2.0)
      stickyButton.tag = ViewTags.StickyBillButton.rawValue
      
      stickyButton.addTarget(self, action: #selector(billTapped), for: UIControlEvents.touchUpInside)
      UIApplication.shared.keyWindow!.addSubview(stickyButton)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyOrderButton.rawValue)?.removeFromSuperview()
    UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyBillButton.rawValue)?.removeFromSuperview()
  }
  
  override func createPresenter() -> BasePresenter {
    return MenuPresenter()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyOrderButton.rawValue)?.isHidden = true
    UIApplication.shared.keyWindow!.viewWithTag(ViewTags.StickyBillButton.rawValue)?.isHidden = true
    
    switch segue.identifier {
    case ReuseIdentifier.toLargeView.rawValue?:
      guard let destVC = segue.destination as? MenuImageViewController else {
        break
      }
      destVC.menuItem = thisItem
//    case ReuseIdentifier.toOrders.rawValue?:
//      guard let _ = segue.destination as? OrdersViewController else {
//        break
//      }
    default:
      break
    }
  }
  
  // MARK: - MenuViewInterface
  func renderMenuList(_ menuList: [Menu]) {
    menuCategories = menuList
    menuCollectionView.delegate = self
    menuCollectionView.dataSource = self
    self.menuCollectionView.reloadData()
    categoryCollectionView.delegate = self
    categoryCollectionView.dataSource = self
    self.categoryCollectionView.reloadData()
  }
  
  func addToOrder(item: MenuItem) {
    if thisBill.order!.items[item.key] == nil {
      // first ordered item
      thisBill.order!.items[item.key] = MenuOrder(item: item)
      self.showIntro()
    } else {
      thisBill.order!.items[item.key]?.quantity += 1
    }
  }
  
  func removeFromOrder(item: MenuItem) {
    guard thisBill.order != nil else {
      return
    }
    
    if thisBill.order!.items[item.key] != nil, thisBill.order!.items[item.key]!.quantity > 1 {
      thisBill.order!.items[item.key]!.quantity -= 1
    } else {
      thisBill.order!.items.removeValue(forKey: item.key)
    }
  }
  
  @objc func orderTapped() {
    guard thisBill.order != nil && thisBill.order!.items.count > 0 else {
      self.renderWarning("Order tray is empty. Let's add something delicious by tap + in the menu.")
      return
    }
    
    self.performSegue(withIdentifier: ReuseIdentifier.toOrders.rawValue, sender: nil)
  }
  
  @objc func billTapped() {
    guard thisBill.order != nil && thisBill.order!.items.count > 0 else {
      self.renderWarning("Order tray is empty. Let's add something delicious by tap + in the menu.")
      return
    }
    guard thisBill.order!.items.filter({ $1.status != .pending }).count > 0 else {
      self.renderWarning("You picked some items that haven't been submitted.\nTap on orders button on the right top corner to submit.")
      return
    }
    guard thisBill.order!.items.filter({ $1.status == .pending }).count == 0 else {
      DispatchQueue.main.asyncAfter(deadline: Constants.DISPATCH_DELAY, execute: {
        self.renderMessage(title: "Confirm", message: "It seems that there are still some items in pending.\n\n Are you sure, you don't want them?", completion: { action in
          if action.style == .default {
            (UIApplication.shared.windows[0].rootViewController as? UINavigationController)?.topViewController?.performSegue(withIdentifier: ReuseIdentifier.toCustomerInfo.rawValue, sender: nil)
          } else {
            self.performSegue(withIdentifier: ReuseIdentifier.toOrders.rawValue, sender: nil)
          }
        })
      })
      return
    }
    
    self.performSegue(withIdentifier: ReuseIdentifier.toCustomerInfo.rawValue, sender: nil)
  }
  
  @objc func catagoryTapped() {
    
  }
  
  // TODO: - Intro on Menu view (first order tooltip to submit)
  private func showIntro() {
    
  }
}

// MARK: - UICollectionViewDataSource
extension MenuViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return collectionView.tag == MenuCollectionViews.Menu.rawValue ? menuCategories.count : 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionView.tag == MenuCollectionViews.Menu.rawValue ? menuCategories[section].menuItems.count : menuCategories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == "UICollectionElementKindSectionHeader", let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIdentifier.sectionHeader.rawValue, for: indexPath) as? SectionHeader {
      sectionHeader.sectionHeaderLabel.text = menuCategories[indexPath.section].categoryName
      return sectionHeader
    }
    return UICollectionReusableView()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.tag == MenuCollectionViews.Menu.rawValue {
      let cell: MenuCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.menuCollectionCell.rawValue, for: indexPath) as! MenuCollectionCell
      let menu: Menu = self.menuCategories[indexPath.section]
      cell.thisItem = menu.menuItems[indexPath.row]
      cell.delegate = self
      return cell
    } else {
      let cell: CategoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.categoryCollectionCell.rawValue, for: indexPath) as! CategoryCollectionCell
      let menu: Menu = self.menuCategories[indexPath.row]
      cell.categoryName = menu.categoryName
      return cell
    }
  }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.tag == MenuCollectionViews.Menu.rawValue {
      return CGSize(width: 236.0, height: 210.0)
    } else {
      return CGSize(width: (collectionView.bounds.size.width - 30)/4, height: (collectionView.bounds.size.height - 10)/2)
    }
  }
}


// MARK: - UICollectionViewDelegate
extension MenuViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView.tag == MenuCollectionViews.Menu.rawValue {
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
    } else {
      self.menuCollectionView.scrollToItem(at: IndexPath(row: 0, section: indexPath.row), at: .top, animated: true)
    }
 
  }

}
