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
}


class MenuViewController: BaseViewController, MenuViewInterface {

  var thisBill: Bill!
  var menuCategories: [Menu]!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private weak var eventHandler: MenuEventsInterface? {
    return baseEventHandler as? MenuEventsInterface
  }
  
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
      
    default:
      break
    }
  }
  
  func renderMenuList(_ menuList: [Menu]) {
    menuCategories = menuList
    collectionView.delegate = self
    collectionView.dataSource = self
    self.collectionView.reloadData()
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
