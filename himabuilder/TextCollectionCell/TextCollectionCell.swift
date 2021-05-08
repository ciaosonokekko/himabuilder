//
//  TextCollectionCell.swift
//  Mambu
//
//  Created by Francesco Cosenza on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit

class TextCollectionCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    
    var data: Text! {
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
        #warning("ALBE USAMII!!")
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
