//
//  MYLTextFieldView.swift
//  MyOrders
//
//  Created by RBC on 2018-07-16.
//  Copyright © 2018 RBC. All rights reserved.
//

import UIKit

class MYLTextFieldView: UIView {

  @IBOutlet var contentView: UIView!
  @IBOutlet weak var fieldImage: UIImageView!
  @IBOutlet weak var fieldText: UITextField!
  @IBOutlet weak var bottomLine: UIView!
  @IBOutlet weak var errorMessage: UILabel!
  @IBOutlet weak var errorImage: UIImageView!
  @IBOutlet weak var fieldTextLeading: NSLayoutConstraint!
  
  var maximumValueLength: Int = 0
  var fieldValidationType: UInt = 0
  var delegate: UITextFieldDelegate? = nil {
    didSet {
      fieldText.delegate = delegate
    }
  }
  
  var fieldState: FieldState = .normal {
    didSet {
      switch fieldState {
      case .normal:
        isValid = true
        bottomLine.backgroundColor = UIColor.textFieldBorderColor()
      case .focus:
        bottomLine.backgroundColor = UIColor.textFieldFocusedBorderColor()
      case .error:
        isValid = false
        bottomLine.backgroundColor = UIColor.textFieldErrorColor()
      }
      self.setNeedsDisplay()
    }
  }
  
  private var isValid: Bool = true
  
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
    fieldValidationType = validationType ?? ValidationType.None.rawValue
    
    if error != nil, !value!.isEmpty {
      fieldText.text = value!
      fieldState = .error
    } else {
      errorMessage.text = ""
      errorMessage.isHidden = true
      errorImage.isHidden = true
      
      fieldState = .normal
    }
    
    self.layoutSubviews()
  }
  
  func configure(placeholder: String?, validationType: UInt, maxLength: Int = 0, alignment: NSTextAlignment = .left, keyboardType: UIKeyboardType = .default) {
    self.configure(image: nil, placeholder: placeholder, value: nil, validationType: validationType, error: nil)
    fieldText.textAlignment = alignment
    fieldText.keyboardType = keyboardType
    maximumValueLength = maxLength
  }
  
  func validate() {
    guard fieldText.text != nil, fieldValidationType > 0 else {
      return
    }
    
    let trimedVal: String = fieldText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    var curValidation: ValidationType = .IsRequired
    
    isValid = true
    
    while curValidation.rawValue <= fieldValidationType, curValidation.rawValue <= ValidationType.IsPostcode.rawValue {
      if (fieldValidationType & curValidation.rawValue) == curValidation.rawValue {
        
        if curValidation == .IsRequired {
          if trimedVal.isEmpty {
            isValid = false
            errorMessage.text = curValidation.error
            bottomLine.backgroundColor = UIColor.textFieldErrorColor()
            return
          }
        } else if trimedVal.isEmpty {
          return
        }
        
        do {
          let regex = try NSRegularExpression(pattern: curValidation.regex)
          let results = regex.matches(in: trimedVal, range: NSRange(trimedVal.startIndex..., in: trimedVal))
          
          if results.count == 0 {
            isValid = false
            errorMessage.text = curValidation.error
            bottomLine.backgroundColor = UIColor.textFieldErrorColor()
            return
          }
          
        } catch {
          print("invalid regex: \(error.localizedDescription)")
        }
      }
      
      curValidation = ValidationType.init(rawValue: curValidation.rawValue * 2)!
    }
    
    errorMessage.text = ""
    errorMessage.isHidden = true
    errorImage.isHidden = true
    bottomLine.backgroundColor = UIColor.textFieldBorderColor()
  }

  private func loadViewFromNib() {
    guard self.viewWithTag(99) == nil else {
      return
    }
    Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
    contentView.tag = 99
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    contentView.translatesAutoresizingMaskIntoConstraints = true
    fieldText.delegate = self
    
    self.isAccessibilityElement = true
  }
  
}

extension MYLTextFieldView: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.fieldState = .focus
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.fieldState = .normal
  }
  
  func textFieldValueChanged(_ textField: UITextField) {
    if maximumValueLength == 0 {
      return
    }
    
    if let text = textField.text {
      if text.count > maximumValueLength {
        textField.text = text.getSubstring(fromIndex: text.startIndex, to: maximumValueLength)
      }
    }
  }
}
