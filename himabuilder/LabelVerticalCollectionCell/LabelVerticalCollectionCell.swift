//
//  LabelVerticalCollectionCell.swift
//  himabuilder
//
//  Created by Francesco Cosenza on 13/10/21.
//

import UIKit

class LabelVerticalCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!

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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick)))
        
        self.lblValue.textColor = .systemGray
    }
    
    @objc func onClick() {
        data.onClick?(data, self)
    }
    
    open override func prepareForReuse() {
        self.lblTitle.text = nil
        self.lblValue.text = ""
    }
    
    func setup() {
//        self.container.backgroundColor = .systemBackground
//        self.container.clipsToBounds = true
        self.lblTitle.text = data.title
        self.lblValue.text = data.value
//        self.lblValue.backgroundColor = .red
//        self.lblValue.sizeToFit()
        
        evaluateMandatory()
    }
    
    func evaluateMandatory() {
        if data.mandatory && data.value == nil {
            self.lblTitle.textColor = .red
        } else {
            self.lblTitle.textColor = .label
        }
    }
    
    public func updateValue(_ genericRepresentable: GenericRepresentable?) {
        updateValue(genericRepresentable?._title)
    }
    
    public func updateValue(_ value: String?) {
        data.value = value
        setup()
    }

}
