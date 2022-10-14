//
//  TextCollectionCell.swift
//  Mambu
//
//  Created by Francesco Cosenza on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit

class TextAreaCollectionCell: UICollectionViewCell, UITextViewDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextView!
    
    var data: TextArea! {
        didSet {
            setup()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func setupUI() {
        // base setup ui
    }
    
    override func prepareForReuse() {
        #warning("ALBE USAMIIII!!!")
    }
    
    func setup() {
        self.lblTitle.text = data.title
        if data.value == "" {
            self.txtValue.text = "Tocca qui per scrivere"
            self.txtValue.textColor = .systemGray
        } else {
            self.txtValue.text = data.value
        }
        if !data.editable {
            self.txtValue.text = data.value
            self.txtValue.textColor = .systemGray
        }
        self.txtValue.isUserInteractionEnabled = data.editable
        self.txtValue.delegate = self
        evaluateMandatory()
    }
    
    func evaluateMandatory() {
        if data.mandatory && data.value?.isEmpty ?? true {
            self.lblTitle.textColor = .red
        } else {
            self.lblTitle.textColor = .label
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !data.editable { return }
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tocca qui per scrivere"
            textView.textColor = UIColor.systemGray
            if data.mandatory {
                self.lblTitle.textColor = .red
            }
        } else {
            self.lblTitle.textColor = .label
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        data.onValueUpdate?(data, textView.text)
    }
    
}
