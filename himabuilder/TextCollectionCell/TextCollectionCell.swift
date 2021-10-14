//
//  TextCollectionCell.swift
//  Mambu
//
//  Created by Francesco Cosenza on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit
import LUAutocompleteView

public class TextCollectionCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    
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
        
        self.txtValue.keyboardType = data.keyboardType
        
        evaluateMandatory()
    }
    
    func evaluateMandatory() {
        if data.mandatory && data.value?.isEmpty ?? true {
            self.lblTitle.textColor = .red
        } else {
            self.lblTitle.textColor = .label
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
}
