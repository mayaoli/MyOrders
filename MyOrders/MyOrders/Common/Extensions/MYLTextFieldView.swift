//
//  MYLTextFieldView.swift
//  MyOrders
//
//  Created by Yaoli.Ma on 2018-07-16.
//  Copyright © 2018 Yaoli.Ma. All rights reserved.
//

import UIKit

class MYLTextFieldView: UIView {

  @IBOutlet var contentView: UIView!
  @IBOutlet weak var fieldImage: UIImageView!
  @IBOutlet weak var fieldText: MYLTextField!
  @IBOutlet weak var bottomLine: UIView!
  @IBOutlet weak var errorMessage: UILabel!
  @IBOutlet weak var errorImage: UIImageView!
  @IBOutlet weak var fieldTextLeading: NSLayoutConstraint!
  
  var isValid: Bool = true
  var maximumValueLength: Int = 0
  weak var delegate: UIViewController? = nil {
    didSet {
      fieldText.delegate = delegate as? UITextFieldDelegate
    }
  }
  
  var fieldState: FieldState = .normal {
    didSet {
      switch fieldState {
      case .normal:
        isValid = true
        errorMessage.text = ""
        errorMessage.isHidden = true
        errorImage.isHidden = true
        bottomLine.backgroundColor = UIColor.textFieldBorderColor()
      case .focus:
        bottomLine.backgroundColor = UIColor.textFieldFocusedBorderColor()
      case .error(let message):
        isValid = false
        bottomLine.backgroundColor = UIColor.textFieldErrorColor()
        errorMessage.text = message
        errorMessage.isHidden = false
        errorImage.isHidden = false
      }
      self.setNeedsDisplay()
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadViewFromNib()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadViewFromNib()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    loadViewFromNib()
  }
  
  func configure(image: UIImage?, placeholder: String?, value: String?, validationType: UInt?, error: String?) {
    
    if image != nil {
      fieldImage.image = image!
    } else {
      fieldImage.isHidden = true
      fieldTextLeading.constant = -21
    }
    
    fieldText.placeholder = placeholder ?? "Please enter"
    fieldText.text = value ?? ""
    fieldText.fieldValidationType = validationType ?? ValidationType.None.rawValue
    
    if error != nil, !value!.isEmpty {
      fieldText.text = value!
      fieldState = .error(message: error!)
    } else {
      fieldState = .normal
    }
    
    fieldText.addTarget(self, action: #selector(valueChanged), for: UIControlEvents.editingChanged)
    
    self.layoutSubviews()
  }
  
  func configure(placeholder: String?, validationType: UInt, maxLength: Int = 0, alignment: NSTextAlignment = .left, keyboardType: UIKeyboardType = .default) {
    self.configure(image: nil, placeholder: placeholder, value: nil, validationType: validationType, error: nil)
    fieldText.textAlignment = alignment
    fieldText.keyboardType = keyboardType
    maximumValueLength = maxLength
  }
  
  func validate() {
    if let err = fieldText.validate() {
      fieldState = .error(message: err)
    } else {
      fieldState = .normal
    }
  }
  
  private func loadViewFromNib() {
    guard self.viewWithTag(ViewTags.TextFieldView.rawValue) == nil else {
      return
    }
    Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
    contentView.tag = ViewTags.TextFieldView.rawValue
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    contentView.translatesAutoresizingMaskIntoConstraints = true
    fieldText.parentView = self
    
    self.isAccessibilityElement = true
  }
  
  func beginEditing() {
    self.fieldState = .focus
  }
  
  func endEditing() {
    self.fieldState = .normal
  }
  
  @objc func valueChanged() {
    if maximumValueLength == 0 {
      return
    }
    
    if let text = fieldText.text {
      if text.count > maximumValueLength {
        fieldText.text = text.getSubstring(fromIndex: text.startIndex, to: maximumValueLength)
      }
    }
  }
}
