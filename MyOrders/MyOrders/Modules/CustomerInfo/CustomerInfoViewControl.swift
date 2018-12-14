//
//  CustomerInfoViewControl.swift
//  MyOrders
//
//  Created by Yaoli Ma on 2018-09-26.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit

protocol CustomerInfoViewInterface: BaseViewInterface {
  func refreshView()
  func renderCustomerInfo()
}

class CustomerInfoViewControl: BaseTextFieldViewController, CustomerInfoViewInterface {

  @IBOutlet weak var staffPINCloseButton: UIButton!
  @IBOutlet weak var staffInputView: UIView!
  @IBOutlet weak var staffPIN: MYLTextFieldView!{
    didSet {
      staffPIN.configure(placeholder: nil, validationType: ValidationType.IsRequired.rawValue + ValidationType.IsNumeric.rawValue + ValidationType.IsPIN.rawValue, maxLength: 6, alignment: .left, keyboardType: .numberPad)
      staffPIN.bind { if $0.count > 4 { Bill.sharedInstance.billPIN = $0 } }
    }
  }
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var buttonPanel: UIView!
  
  @IBOutlet weak var ageContainerView: UIView!
  @IBOutlet weak var ageInputView: UIView!
  @IBOutlet weak var ageSegmentYConstraint: NSLayoutConstraint!
  @IBOutlet weak var ageSegment: UISegmentedControl!
  
  @IBOutlet weak var payMethodSegment: UISegmentedControl!
  private var tapPayGestureRecognizer:UITapGestureRecognizer!
  
  private var tapAnywhereGestureRecognizer:UITapGestureRecognizer!
  private var agePicker: UIPickerView!
  private var theCustomers: [Customer]!
  
  private var valueChanged :(UInt) -> () = { _ in }
  
  private weak var eventHandler: CustomerEventsInterface? {
    return baseEventHandler as? CustomerEventsInterface
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Customer Information"
    
    if let smCustomers = StorageManager.getObject(path: Constants.STORAGE_CUSTOMER_PATH) as? [Customer] {
      if Bill.sharedInstance.customers?.count == smCustomers.count {
        Bill.sharedInstance.customers = smCustomers
      } else if let theseCustomers = Bill.sharedInstance.customers {
        var idx: Int = 0
        while theseCustomers.count > idx, smCustomers.count > idx {
          Bill.sharedInstance.customers![idx] = smCustomers[idx]
          idx += 1
        }
      } else {
        _ = StorageManager.deleteObject(path: Constants.STORAGE_CUSTOMER_PATH)
      }
    }
    
    staffPIN.fieldText.returnKeyType = .next
    staffPIN.delegate = self
    staffInputView.shadow(radius: 10)
    
    tapAnywhereGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedAnywhere(_:)))
    tapAnywhereGestureRecognizer.cancelsTouchesInView = false
    tapAnywhereGestureRecognizer.delegate = self
    
    tableView.register(ReuseIdentifier.baseHeaderCell.nib, forHeaderFooterViewReuseIdentifier: ReuseIdentifier.baseHeaderCell.rawValue)
    tableView.register(ReuseIdentifier.customerTableCell.nib, forCellReuseIdentifier: ReuseIdentifier.customerTableCell.rawValue)
    tableView.register(ReuseIdentifier.addCustomerTableCell.nib, forCellReuseIdentifier: ReuseIdentifier.addCustomerTableCell.rawValue)
    tableView.register(ReuseIdentifier.paymentTableCell.nib, forCellReuseIdentifier: ReuseIdentifier.paymentTableCell.rawValue)
    
    let font: [AnyHashable : Any] = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 32)]
    ageSegment.setTitleTextAttributes(font, for: .normal)
    ageSegment.setWidth(132.0, forSegmentAt: 0)
    ageSegment.setWidth(132.0, forSegmentAt: 1)
    ageSegment.setWidth(132.0, forSegmentAt: 2)
    
    // payment method
    self.payMethodSegment.removeAllSegments()
    PaymentMethod.allCases.forEach { p in
      if p != .other {
        self.payMethodSegment.insertSegment(withTitle: p.rawValue, at: p.index, animated: false)
      }
    }
    payMethodSegment.setTitleTextAttributes(font, for: .normal)
    payMethodSegment.setWidth(102.0, forSegmentAt: 0)
    payMethodSegment.setWidth(168.0, forSegmentAt: 1)
    payMethodSegment.setWidth(178.0, forSegmentAt: 2)
    tapPayGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(paymentMethodTapped(_:)))
    tapPayGestureRecognizer.cancelsTouchesInView = false
    tapPayGestureRecognizer.delegate = self
    
    if let pay =  Bill.sharedInstance.payment {
      if pay.paymentMethod.index >= 0 {
        payMethodSegment.selectedSegmentIndex = pay.paymentMethod.index
      }
    } else {
      Bill.sharedInstance.payment = Payment()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    staffPINCloseButton.isHidden = false
    staffInputView.isHidden = false
    staffPIN.fieldText.becomeFirstResponder()
    tableView.isHidden = true
    buttonPanel.isHidden = true
    payMethodSegment.addGestureRecognizer(self.tapPayGestureRecognizer)
  }
  
  override func createPresenter() -> BasePresenter {
    return CustomerInfoPresenter()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    staffPIN.fieldText.text = ""
    
    payMethodSegment.removeGestureRecognizer(tapPayGestureRecognizer)
    
    StorageManager.setObject(objToSave: theCustomers as NSArray, path: Constants.STORAGE_CUSTOMER_PATH)
  }
  
  
  @IBAction func closeTapped(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func nextTapped(_ sender: Any) {
    self.staffPIN.validate()
    if self.staffPIN.isValid {
      self.eventHandler?.validatePIN(Bill.sharedInstance.billPIN)
    }
  }
  
  @IBAction func AgeSegmentValueChanged(_ sender: Any) {
    switch ageSegment.selectedSegmentIndex {
    case 0:
      self.valueChanged(PriceRange.adult.age)
      self.ageContainerView.isHidden = true
      self.view.removeGestureRecognizer(tapAnywhereGestureRecognizer)
      self.tableView.allowsSelection = true
      self.tableView.reloadData()
    case 1:
      self.valueChanged(PriceRange.senior.age)
      self.ageContainerView.isHidden = true
      self.view.removeGestureRecognizer(tapAnywhereGestureRecognizer)
      self.tableView.allowsSelection = true
      self.tableView.reloadData()
    default:
      showPicker(ageSegment.tag)
    }
  }
  
  @IBAction func PaymentMethodChanged(_ sender: Any) {
    Bill.sharedInstance.payment?.paymentMethod = PaymentMethod.allCases[self.payMethodSegment.selectedSegmentIndex]
  }
  
  private func showAgeInputView(_ priceRange: PriceRange) {
    let eps: CGFloat = 1e-5
    
    self.tableView.allowsSelection = false
    ageContainerView.isHidden = false
    ageContainerView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    ageContainerView.transform = CGAffineTransform(scaleX: eps, y: eps)
    ageContainerView.updateConstraints()
    
    ageInputView.shadow(radius: 10)
    ageSegment.selectedSegmentIndex = priceRange.index
    ageSegment.tag = Int(priceRange.age)
    
    if self.agePicker != nil, priceRange.index != PriceRange.kid(age: priceRange.age).index {
      self.agePicker.isHidden = true
      self.ageSegmentYConstraint.constant = 0
    }
    
    UIView.animate(withDuration: Constants.ANIMATION_DURATION,
                   delay: 0.0,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 0.5,
                   options: UIViewAnimationOptions(),
                   animations: {
                    self.ageContainerView.transform = CGAffineTransform(translationX: -self.ageContainerView.bounds.width/2, y: 0)
    }) { _ in
      if priceRange == PriceRange.kid(age: priceRange.age) {
        self.showPicker(Int(priceRange.age))
      }
      //
      self.view.addGestureRecognizer(self.tapAnywhereGestureRecognizer)
    }
    
  }
  
  func renderCustomerInfo() {
    self.staffInputView.endEditing(true)
    staffPINCloseButton.isHidden = true
    self.staffInputView.isHidden = true
    self.tableView.isHidden = false
    self.buttonPanel.isHidden = false
  }
  
  func refreshView() {
    self.tableView.reloadData()
  }
  
  @IBAction func okayButtonTapped(_ sender: Any) {
    view.endEditing(true)
    ageContainerView.isHidden = true
    view.removeGestureRecognizer(tapAnywhereGestureRecognizer)
    self.tableView.allowsSelection = true
    self.tableView.reloadData()
  }
  
  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard textField.returnKeyType == .next else {
      return false
    }
    
    self.nextTapped(self)
    
    return true
  }
}


// MARK: - Table view data source
extension CustomerInfoViewControl: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    theCustomers = Bill.sharedInstance.customers!
    return self.eventHandler?.getRowNumber(section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let  headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifier.baseHeaderCell.rawValue) as! BaseHeaderCell
    
    headerCell.headerTitle.text = self.eventHandler?.getSectionTitle(section) ?? ""
    
    return headerCell
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // customer information
    if indexPath.row < theCustomers.count {
      let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.customerTableCell.rawValue, for: indexPath) as! CustomerTableCell
      cell.sequenceNum.text = "\(indexPath.row + 1)"
      cell.thisCustomer = theCustomers[indexPath.row]
      cell.delegate = self
      return cell
    } else {
      // add new customer
      let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.addCustomerTableCell.rawValue, for: indexPath) as! AddCustomerTableCell
      cell.delegate = self
      cell.accessoryType = .none
      cell.selectionStyle = .none
      return cell
    }
  }
}

extension CustomerInfoViewControl: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row < theCustomers.count else {
      tableView.deselectRow(at: indexPath, animated: true)
      return
    }
    
//    if theCustomers[indexPath.row].priceRange == .none {
//      self.valueChanged(PriceRange.adult.age)
//    }
    
    self.bind(priceRange: theCustomers[indexPath.row].priceRange) {
      self.theCustomers[indexPath.row].priceRange = (self.eventHandler?.getPriceRange($0))!
    }
    
    defer {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section == 0 && indexPath.row < theCustomers.count
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      self.eventHandler?.removeCustomer(indexPath.row)
    }
  }
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
    self.showAgeInputView(priceRange)
  }
}

// MARK: UIGestureRecognizerDelegate
extension CustomerInfoViewControl: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldReceive touch: UITouch) -> Bool {
    // touch.view === self.ageInputView || ?
    return (touch.view === self.tableView || touch.view === self.view || touch.view === self.payMethodSegment)
  }
  
  @objc private func tappedAnywhere(_ tap: UITapGestureRecognizer) {
    if tap.state == .ended {
      view.endEditing(true)
      ageContainerView.isHidden = true
      view.removeGestureRecognizer(tapAnywhereGestureRecognizer)
      self.tableView.allowsSelection = true
      self.tableView.reloadData()
    }
  }
  
  @objc private func paymentMethodTapped(_ tap: UITapGestureRecognizer) {
    if tap.state == .ended {
      DispatchQueue.main.asyncAfter(deadline: Constants.DISPATCH_DELAY, execute: {
        let err = Bill.sharedInstance.validateCustomers()
        guard err == nil else {
          self.renderError(.customError(message: err!))
          return
        }
        
        self.performSegue(withIdentifier: ReuseIdentifier.toBill.rawValue, sender: nil)
      })
    }
  }
}
