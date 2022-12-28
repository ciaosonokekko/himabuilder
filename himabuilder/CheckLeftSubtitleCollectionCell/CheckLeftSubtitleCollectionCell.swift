//
//  CheckCollectionCell.swift
//  himabuilder
//
//  Created by Francesco Cosenza on 11/10/21.
//

import UIKit

class CheckLeftSubtitleCollectionCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var check: UISwitch!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var extraTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    open var data: Check! {
        didSet {
            setup()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func prepareForReuse() {
        self.title.text = nil
        self.subTitle.text = nil
        self.check.isOn = false
    }
    
    func setup() {
        self.title.text = data.title
        self.subTitle.text = data.subtitle
        self.check.isOn = data.value?.description == "true"
        self.check.addTarget(self, action: #selector(onValueChange(sender:)), for: .valueChanged)
        if self.data.hasExtraTextField == false {
            if self.extraTextField != nil {
                self.extraTextField.removeFromSuperview()
            }
        } else {
            self.extraTextField.delegate = self
        }
    }
    
    @objc func onValueChange(sender: UISwitch) {
        data.onValueUpdate?(data, sender.isOn.description)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        data.extraValue = textField.text
        data.onExtraValueUpdate?(data, textField.text)
        evaluateMandatory()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        data.extraValue = textField.text
        data.onEndEditing?(self, data, textField.text)
        evaluateMandatory()
    }
    
    public func updateValue(genericRepresentable: GenericRepresentable?) {
        updateValue(value: genericRepresentable?._title)
    }
    
    public func updateValue(value: String?) {
        data.extraValue = value
        setup()
    }
    
    func evaluateMandatory() {
        if data.mandatory && data.hasExtraTextField && data.extraValue?.isEmpty ?? true {
            self.extraTextField.attributedPlaceholder = NSAttributedString(
                string: extraTextField.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
            )
        } else {
            self.extraTextField.attributedPlaceholder = NSAttributedString(
                string: extraTextField.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            )
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
