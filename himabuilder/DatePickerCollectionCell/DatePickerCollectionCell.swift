//
//  DatePickerCollectionCell.swift
//  himabuilder
//
//  Created by Francesco on 11/02/22.
//

import UIKit

class DatePickerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pickerDate: UIDatePicker!

    open var data: PickerDate! {
        didSet {
            setup()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    fileprivate func setupUI() {
        self.pickerDate.timeZone = TimeZone(secondsFromGMT: 0)
        if #available(iOS 14.0, *) {
            pickerDate.preferredDatePickerStyle = .compact
        } else {
            // Fallback on earlier versions
        }
        pickerDate.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    public override func prepareForReuse() {
        self.pickerDate.date = Date()
        self.lblTitle.text = nil
    }
    
    public func updateValue(value: String?) {
        data.value = value
        setup()
    }
    
    func setup() {
        self.lblTitle.text = data.title
        self.pickerDate.setDate(data.dataValue ?? Date(), animated: true)
    }
    
    @objc func handleDatePicker(_ datePicker: UIDatePicker) {
        data.onDataValueUpdate?(data, datePicker.date)
    }

}
