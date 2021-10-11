//
//  CheckCollectionCell.swift
//  himabuilder
//
//  Created by Francesco Cosenza on 11/10/21.
//

import UIKit

class CheckCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var check: UISwitch!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!

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
        self.subTitle.text = data.title
        self.check.isOn = data.value?.description == "true"
        self.check.addTarget(self, action: #selector(onValueChange(sender:)), for: .valueChanged)
    }
    
    @objc func onValueChange(sender: UISwitch) {
        data.onValueUpdate?(data, sender.isOn.description)
    }
}
