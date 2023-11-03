//
//  TextCollectionCell.swift
//  Mambu
//
//  Created by Francesco Cosenza on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit

open class TextAreaCollectionCell: UICollectionViewCell, UITextViewDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextView!
    
    var data: TextArea! {
        didSet {
            setup()
        }
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        // base setup ui
    }
    
    override open func prepareForReuse() {
        lblTitle.text = nil
        txtValue.text = nil
    }
    
    func setup() {
        self.lblTitle.text = data.title
        if data.value?.isEmpty ?? true {
            self.txtValue.text = "Tocca qui per scrivere"
            self.txtValue.textColor = .systemGray
        } else {
            self.txtValue.text = data.value
            self.txtValue.textColor = .label
        }
        if data.editable {
            // nothing to do??
            self.txtValue.textColor = .label
        } else {
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
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if !data.editable { return }
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
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
    
    public func textViewDidChange(_ textView: UITextView) {
        data.onValueUpdate?(data, textView.text)
    }
    
}
