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
        self.txtValue.text = data.value
        self.txtValue.delegate = self
        self.txtValue.text = "Tocca qui per scrivere"
        self.txtValue.textColor = UIColor.systemGray
        evaluateMandatory()
    }
    
    func evaluateMandatory() {
        if data.mandatory && data.value == nil {
            self.lblTitle.textColor = .red
        } else {
            self.lblTitle.textColor = .label
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tocca qui per scrivere"
            textView.textColor = UIColor.systemGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        data.onValueUpdate?(data, textView.text)
    }
    
}
