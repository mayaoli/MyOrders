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
  
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */
  
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
    
//    switch indexPath.item {
//    case 0:
//      let dollars = clientInfo?.earnedDollars ?? ""
//      cell.valueEarnedLabel.text = dollars
//      cell.valueTypeLabel.text = R.string.saved^
//    case 1:
//      let earnedPoints = clientInfo?.earnedPoints ?? 0 //Total number of available offers to the client
//      cell.valueEarnedLabel.text = "\(earnedPoints)"
//      cell.valueTypeLabel.text = R.string.available^
//    case 2:
//      let expiringOffers = clientInfo?.expiringOffers ?? 0
//      cell.valueEarnedLabel.text = "\(expiringOffers)"
//      cell.valueTypeLabel.text = R.string.expiring_offers^
//    default:
//      break
//    }
//
//    if indexPath.row < 2 {
//      cell.seperator.isHidden = false
//      cell.seperator.backgroundColor = UIColor(red: 115.0/255.0, green: 176.0/255.0, blue: 227.0/255.0, alpha: 1.0)
//    }
//    else {
//      cell.seperator.isHidden = true
//    }
    
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.size.width/3, height: 70)
  }
}


// MARK: - UICollectionViewDelegate
extension MenuViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
//    guard let searches = recentSearches else {
//      return
//    }
//    let maximumAllowedCell = min(searches.count, Constants.maximumRecentSearches)
//
//    if indexPath.row >= maximumAllowedCell {
//      delegate?.didSelectSeeOnAllSearches()
//    } else {
//      delegate?.didSelectRecentSearch(searchParams: searches[indexPath.row])
//      AnalyticsManager.trackRecentSearchTileClick()
//    }
  }
}
