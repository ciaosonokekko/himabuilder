//
//  LinearSelectCollectionCell.swift
//  Mambu
//
//  Created by Alberto on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit


public class PushCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    var data: Push! {
        didSet {
            setup()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    public override func prepareForReuse() {
        self.lblTitle.text = nil
        self.lblValue.text = "Tocca per selezionare"
    }
    
    fileprivate func setupUI() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick)))
    }
    
    func setup() {
        if data.value == nil {
            self.lblValue.textColor = .systemGray3
            self.lblTitle.text = "Tocca per selezionare"
        } else {
            self.lblValue.textColor = .label
            self.lblValue.text = data.value
        }
        self.lblTitle.text = data.title
        
    }
    
    @objc func onClick() {
        data.onClick?(data, self)
    }
    
    public func updateValue(_ genericRepresentable: GenericRepresentable?) {
        updateValue(genericRepresentable?._title)
    }
    
    public func updateValue(_ value: String?) {
        data.value = value
        setup()
    }

}
