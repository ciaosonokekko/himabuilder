//
//  LabelVerticalCollectionCell.swift
//  himabuilder
//
//  Created by Francesco Cosenza on 13/10/21.
//

import UIKit

public class LabelVerticalCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btnIcon: UIButton!
    
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
        self.btnIcon.isHidden = true
    }
    
    func setup() {
//        self.container.backgroundColor = .systemBackground
//        self.container.clipsToBounds = true
        self.lblTitle.text = data.title
        self.lblValue.text = data.value
//        self.lblValue.backgroundColor = .red
//        self.lblValue.sizeToFit()
        
        if let btnImage = self.data.buttonIcon {
            btnIcon.setTitle("", for: .normal)
            btnIcon.setImage(btnImage, for: UIControl.State.normal)
            btnIcon.contentMode = .scaleAspectFit
            btnIcon.addTarget(self, action:#selector(self.buttonIconTapped), for: .touchUpInside)
            btnIcon.isHidden = false
        }
        
        evaluateMandatory()
    }
    
    @objc func buttonTapped() {
        data.onClick?(data, self)
    }
    
    @objc func buttonIconTapped() {
        if !self.data.editable { return }
        data.onButtonIconClick?(data, self)
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
