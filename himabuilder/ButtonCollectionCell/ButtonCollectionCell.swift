//
//  LinearSelectCollectionCell.swift
//  Mambu
//
//  Created by Alberto on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit

public class ButtonCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    open var data: Button! {
        didSet {
            setup()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func prepareForReuse() {
        self.button.setTitle("", for: .normal)
    }
    
    func setup() {
        self.button.setTitle(data.title, for: .normal)
        self.button.setTitleColor(data.btnColor, for: .normal)
        
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        self.onClick()
    }
    
    @objc func onClick() {
        data.onClick?(data, self)
    }

}
