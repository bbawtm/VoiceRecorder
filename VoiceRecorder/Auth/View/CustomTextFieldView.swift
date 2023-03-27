//
//  CustomTextFieldView.swift
//  VK Education – Assignment #5 (private)
//  https://github.com/VKEducation/ios-itmo-2022-assignment-5-bbawtm/blob/main/Assignment%20%235/Controllers/Templates/CustomTextFieldView.swift
//
//  Created by Vadim Popov on 30.11.2022.
//

import UIKit


extension UITextField {
    
    // UIDatePicker implementation
    func setDatePickerAsInputViewFor(selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        self.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tapCancel))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: selector)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}

//
// Custom Text field
//
// init:
//    - label
//    - placeholder
//    - selector? (for .editingChanged)
//    - contentType?
//
// isCorrect: check if the value is correct
//
// getField: get current textfield element
//
// getValue: get current field value or ""
//
// setTextValue: set String value to the field
//
class CustomTextFieldView : UIView {
    
    private var label: UILabel = {
        let subview = UILabel()
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.font = subview.font.withSize(12)
        subview.textColor = .label
        
        return subview
    }()
    
    private var field: UITextField = {
        let subview = UITextField()
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.text = nil
        subview.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        subview.layer.cornerRadius = 8
        subview.layer.borderWidth = 1
        subview.layer.borderColor = UIColor.gray.cgColor
        subview.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        subview.leftViewMode = .always
        subview.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        subview.rightViewMode = .always
        subview.isEnabled = true
        subview.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        
        return subview
    }()
    
    private var showsError = false
    
    public var isCorrect: Bool { !showsError && (field.text ?? "").count > 0 }
    
    
    public convenience init(
        label labelText: String,
        placeholder placeholderText: String?,
        contentType: UITextContentType? = nil
    ) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        label.text = labelText
        
        field.placeholder = placeholderText
        if let contentType {
            field.textContentType = contentType
            field.autocorrectionType = .no
            
            if contentType == .password {
                field.isSecureTextEntry = true
                field.autocapitalizationType = .none
            } else if contentType == .username {
                field.autocapitalizationType = .none
            } else if contentType == .emailAddress {
                field.keyboardType = .emailAddress
                field.autocapitalizationType = .none
            }
        }
        
        addSubview(label)
        addSubview(field)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: field.topAnchor, constant: -8),
            label.leftAnchor.constraint(equalTo: leftAnchor),
            
            field.heightAnchor.constraint(equalToConstant: 50),
            field.leftAnchor.constraint(equalTo: leftAnchor),
            field.rightAnchor.constraint(equalTo: rightAnchor),
            field.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func setChecker(checker: @escaping () -> Void) {
        field.addAction(UIAction { action in
            checker()
        }, for: .editingChanged)
    }
    
    public func usingDatePicker(selector: Selector) {
        field.setDatePickerAsInputViewFor(selector: selector)
    }
    
    public func getField() -> UITextField {
        return field
    }
    
    public func getValue() -> String {
        return field.text ?? ""
    }
    
    public func setTextValue(_ text: String?) {
        field.text = text
    }
    
    public func showError() {
        guard !showsError else { return }
        
        label.textColor = .systemRed
        field.layer.borderColor = UIColor.systemRed.cgColor
        showsError = true
    }
    
    public func hideError() {
        guard showsError else { return }
        
        label.textColor = .label
        field.layer.borderColor = UIColor.gray.cgColor
        showsError = false
    }
    
    public func clear() {
        field.text = ""
        hideError()
    }
}
