//
//  LinearSelectCollectionCell.swift
//  Mambu
//
//  Created by Alberto on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import UIKit


class ButtonCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    var data: Button! {
        didSet {
            setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.button.setTitle("", for: .normal)
    }
    
    func setup() {
        self.button.setTitle(data.title, for: .normal)
        
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        self.onClick()
    }
    
    @objc func onClick() {
        data.onClick?(data, self)
    }

}
