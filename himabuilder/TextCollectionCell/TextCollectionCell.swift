//
//  TextCollectionCell.swift
//  Mambu
//
//  Created by Francesco Cosenza on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit

public class TextCollectionCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnIcon: UIButton!
    
    public var data: Text! {
        didSet {
            setup()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    fileprivate func setupUI() {
        self.txtValue.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.txtValue.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        data.value = textField.text
        data.onValueUpdate?(data, textField.text)
        evaluateMandatory()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        data.value = textField.text
        data.onEndEditing?(self, data, textField.text)
        evaluateMandatory()
    }
    
    public override func prepareForReuse() {
        self.lblTitle.text = nil
        self.txtValue.text = nil
        self.btnIcon.isHidden = true
        // todo: hide button
    }
    
    public func updateValue(genericRepresentable: GenericRepresentable?) {
        updateValue(value: genericRepresentable?._title)
    }
    
    public func updateValue(value: String?) {
        data.value = value
        setup()
    }
    
    func setup() {
        self.lblTitle.text = data.title
        self.txtValue.text = data.value
        self.txtValue.isUserInteractionEnabled = data.editable
        self.txtValue.textColor = data.editable ? .label : .systemGray
        
        
        if let btnImage = self.data.buttonIcon {
            btnIcon.setTitle("", for: .normal)
            btnIcon.setImage(btnImage, for: UIControl.State.normal)
            btnIcon.contentMode = .scaleAspectFit
            btnIcon.addTarget(self, action:#selector(self.buttonTapped), for: .touchUpInside)
            btnIcon.isHidden = false
        }
        
        self.txtValue.keyboardType = data.keyboardType
        
        evaluateMandatory()
        
        if data.textType == .date || data.textType == .standard {
            return
        }
    }
    
    @objc func buttonTapped() {
        data.onClick?(data, self)
    }
    
    func evaluateMandatory() {
        if data.mandatory && data.value?.isEmpty ?? true {
            self.lblTitle.textColor = .red
        } else {
            self.lblTitle.textColor = .label
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !data.suggestions.isEmpty {
            return !autoCompleteText(in: textField, using: string, suggestionsArray: data.suggestions)
        }
        
        guard data.textType == .date else {
            return true
        }
        
        //Format Date of Birth dd-MM-yyyy
        if (textField.text?.count == 2) || (textField.text?.count == 5) {
            //Handle backspace being pressed
            if !(string == "") {
                // append the text
                textField.text = "\(textField.text ?? "")-"
            }
        }
        // check the condition not exceed 9 chars
        return !((textField.text?.count ?? 0) > 9 && (string.count ) > range.length)
    }
    
    func autoCompleteText(in textField: UITextField, using string: String, suggestionsArray: [String]) -> Bool {
        if !string.isEmpty,
           let selectedTextRange = textField.selectedTextRange,
           selectedTextRange.end == textField.endOfDocument,
           let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
           let text = textField.text( in : prefixRange) {
            let prefix = text + string
            let matches = suggestionsArray.filter {
                $0.lowercased().hasPrefix(prefix.lowercased())
            }
            if (matches.count > 0) {
                textField.text = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }()
    var formatted: String {
        return Date.formatter.string(from: self)
    }
}
