//
//  CustomerInfoViewControl.swift
//  MyOrders
//
//  Created by Yaoli Ma on 2018-09-26.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit

class CustomerInfoViewControl: BaseViewController {

  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var okButton: UIButton!
  
  @IBOutlet weak var ageInputView: UIView!
  @IBOutlet weak var ageSegmentYConstraint: NSLayoutConstraint!
  @IBOutlet weak var ageSegment: UISegmentedControl!
  
  private var gestureRecognizer:UITapGestureRecognizer!
  private var agePicker: UIPickerView!
  private var theCustomers = Bill.sharedInstance.customers!
  
  private var valueChanged :(UInt) -> () = { _ in }
  
  private weak var eventHandler: CustomerEventsInterface? {
    return baseEventHandler as? CustomerEventsInterface
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    if let customers = StorageManager.getObject(path: Constants.STORAGE_CUSTOMER_PATH) {
//      theCustomers = customers as! [Customer]
//    }
    self.title = "Customer Information"
    
    gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedAnywhere(_:)))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    
    tableView.register(ReuseIdentifier.customerTableCell.nib, forCellReuseIdentifier: ReuseIdentifier.customerTableCell.rawValue)
    tableView.register(ReuseIdentifier.paymentTableCell.nib, forCellReuseIdentifier: ReuseIdentifier.paymentTableCell.rawValue)
    
    let font: [AnyHashable : Any] = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 32)]
    ageSegment.setTitleTextAttributes(font, for: .normal)
    ageSegment.setWidth(132.0, forSegmentAt: 0)
    ageSegment.setWidth(132.0, forSegmentAt: 1)
    ageSegment.setWidth(132.0, forSegmentAt: 2)
  }
  
  override func createPresenter() -> BasePresenter {
    return CustomerPresenter()
  }
  
  private func showPopup(_ priceRange: PriceRange) {
    let eps: CGFloat = 1e-5
    
    ageInputView.isHidden = false
    ageInputView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    ageInputView.transform = CGAffineTransform(scaleX: eps, y: eps)
    ageInputView.updateConstraints()
    
    ageInputView.shadow(radius: 10)
    ageSegment.selectedSegmentIndex = priceRange.index
    ageSegment.tag = Int(priceRange.age)
      
    UIView.animate(withDuration: Constants.ANIMATION_DURATION,
                   delay: 0.0,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 0.5,
                   options: UIViewAnimationOptions(),
                   animations: {
                    self.ageInputView.transform = CGAffineTransform(translationX: -self.ageInputView.bounds.width/2, y: 0)
    }) { _ in
      if priceRange == PriceRange.kid(age: priceRange.age) {
        self.showPicker(Int(priceRange.age))
      }
      //
      self.view.addGestureRecognizer(self.gestureRecognizer)
    }
    
  }
  
  func removeCustomer(_ customer: Customer) {
    for idx in 0...(theCustomers.count - 1)  {
      if customer == Bill.sharedInstance.customers![idx] {
        Bill.sharedInstance.customers!.remove(at: idx)
        theCustomers = Bill.sharedInstance.customers!
        self.tableView.reloadData()
        break
      }
    }
  }
  
  @IBAction func okTapped(_ sender: Any) {
    guard let err = Bill.sharedInstance.validateCustomers() else {
      //StorageManager.setObject(objToSave: theCustomers as NSArray, path: Constants.STORAGE_CUSTOMER_PATH)
      performSegue(withIdentifier: ReuseIdentifier.toBill.rawValue, sender: nil)
      return
    }
    
    self.renderError(.customError(message: err))
  }
  
}

// MARK: - Table view data source
extension CustomerInfoViewControl: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.eventHandler?.getRowNumber(section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      // customer information
      
      let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.customerTableCell.rawValue, for: indexPath) as! CustomerTableCell
      
      if indexPath.row < theCustomers.count {
        cell.sequenceNum.text = "\(indexPath.row + 1)"
        cell.thisCustomer = theCustomers[indexPath.row]
      } else {
        cell.sequenceNum.text = ""
        cell.age.text = ""
      }
      cell.delegate = self
      
      return cell
      
    } else {
      // payment method
      let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.paymentTableCell.rawValue, for: indexPath) as! PaymentMethodTableCell
      
      
      return cell
    }
  }
}

extension CustomerInfoViewControl: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if theCustomers[indexPath.row].priceRange == .none {
      self.valueChanged(PriceRange.adult.age)
    }
    
    self.bind(priceRange: theCustomers[indexPath.row].priceRange) {
      self.theCustomers[indexPath.row].priceRange = (self.eventHandler?.getPriceRange($0))!
    }
    
    defer {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  //(void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
}

// MARK: - Picker view data source
extension CustomerInfoViewControl: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 9
  }
}

extension CustomerInfoViewControl: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(row + 4) years old"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.valueChanged(UInt(row + 4))
  }
  
  
  @IBAction func AgeSegmentValueChanged(_ sender: Any) {
    switch ageSegment.selectedSegmentIndex {
    case 0:
      self.valueChanged(PriceRange.adult.age)
      ageInputView.isHidden = true
      self.tableView.reloadData()
    case 1:
      self.valueChanged(PriceRange.senior.age)
      ageInputView.isHidden = true
      self.tableView.reloadData()
    default:
      showPicker(ageSegment.tag)
    }
  }
  
  func showPicker(_ age: Int) {
    UIView.animate(withDuration: Constants.ANIMATION_DURATION, delay: 0,
                   usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .allowUserInteraction,
                   animations: {
                    () -> Void in
                    self.ageSegmentYConstraint.constant = -60.0
                    self.ageInputView.layoutIfNeeded()
    }, completion: nil)
    
    if agePicker == nil {
      agePicker = UIPickerView()
      agePicker.translatesAutoresizingMaskIntoConstraints = false
      agePicker.dataSource = self
      agePicker.delegate = self
      self.ageInputView.addSubview(agePicker)
      
      agePicker.leadingAnchor.constraint(equalTo: ageInputView.leadingAnchor).isActive = true
      agePicker.trailingAnchor.constraint(equalTo: ageInputView.trailingAnchor).isActive = true
      agePicker.bottomAnchor.constraint(equalTo: ageInputView.bottomAnchor).isActive = true
    } else {
      agePicker.isHidden = false
    }
    
    if age >= 4, age <= 12 {
      agePicker.selectRow(age - 4, inComponent: 0, animated: false)
    } else {
      agePicker.selectRow(3, inComponent: 0, animated: false)
      self.valueChanged(7)
    }
  }
  
  func bind(priceRange : PriceRange, callback :@escaping (UInt) -> ()) {
    self.valueChanged = callback
    self.showPopup(priceRange)
  }
}

// MARK: UIGestureRecognizerDelegate
extension CustomerInfoViewControl: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.ageInputView || touch.view === self.tableView || touch.view === self.view)
  }
  
  @objc private func tappedAnywhere(_ tap: UITapGestureRecognizer) {
    if tap.state == .ended {
      view.endEditing(true)
      if agePicker != nil {
        agePicker.isHidden = true
        ageSegmentYConstraint.constant = 0
      }
      ageInputView.isHidden = true
      view.removeGestureRecognizer(gestureRecognizer)
      self.tableView.reloadData()
    }
  }
}
