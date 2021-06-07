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
        data.onValueUpdate?(data, textField.text)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        data.onEndEditing?(data, textField.text)
    }
    
    public override func prepareForReuse() {
        #warning("ALBE USAMII!!")
    }
    
    public func updateValue(_ genericRepresentable: GenericRepresentable?) {
        updateValue(genericRepresentable?._title)
    }
    
    public func updateValue(_ value: String?) {
        data.value = value
        setup()
    }
    
    func setup() {
        self.lblTitle.text = data.title
        self.txtValue.text = data.value
        
        evaluateMandatory()
    }
    
    func evaluateMandatory() {
        if data.mandatory && data.value == nil {
            self.lblTitle.textColor = .red
        } else {
            self.lblTitle.textColor = .label
        }
    }
}
