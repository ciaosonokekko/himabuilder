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
    @IBOutlet var txtHeightConstraint: NSLayoutConstraint!
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Tocca qui per scrivere"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
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
        txtValue.addSubview(placeholderLabel)
        placeholderLabel.frame = CGRect(x: 5, y: 8, width: txtValue.frame.width - 10, height: 20)
        placeholderLabel.isHidden = !txtValue.text.isEmpty
        txtValue.delegate = self
    }
    
    override open func prepareForReuse() {
        lblTitle.text = nil
        txtValue.text = nil
        placeholderLabel.isHidden = false
    }
    
    func setup() {
        self.lblTitle.text = data.title
        if data.value?.isEmpty ?? true {
            self.txtValue.text = ""
            self.placeholderLabel.isHidden = false
        } else {
            self.txtValue.text = data.value
            self.placeholderLabel.isHidden = true
        }
        if !data.editable {
            self.txtHeightConstraint = nil
            placeholderLabel.isHidden = true
        }
        self.txtValue.textColor = data.editable ? .label : .systemGray
        self.txtValue.isUserInteractionEnabled = data.editable
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
        placeholderLabel.isHidden = true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
            if data.mandatory {
                self.lblTitle.textColor = .red
            }
        } else {
            self.lblTitle.textColor = .label
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        data.onValueUpdate?(data, textView.text)
    }
    
}
