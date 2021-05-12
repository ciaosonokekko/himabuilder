//
//  TextCollectionCell.swift
//  Mambu
//
//  Created by Francesco Cosenza on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit

public class LabelCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var container: UIView!
    
    open var data: Label! {
        didSet {
            setup()
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    fileprivate func setupUI() {
        addBorders([.bottom])
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick)))
    }
    
    @objc func onClick() {
        data.onClick?(data, self)
    }
    
    open override func prepareForReuse() {
        self.lblTitle.text = nil
        self.lblValue.text = ""
    }
    
    func setup() {
        self.container.backgroundColor = .systemBackground
        self.container.clipsToBounds = true
        self.lblTitle.text = data.title
        self.lblValue.text = data.value
//        self.lblValue.backgroundColor = .red
        self.lblValue.sizeToFit()
        
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
