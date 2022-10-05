//
//  DatePickerCollectionCell.swift
//  himabuilder
//
//  Created by Francesco on 11/02/22.
//

import UIKit

public class DatePickerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak public var lblTitle: UILabel!
    @IBOutlet weak var pickerDate: UIDatePicker!

    open var data: PickerDate! {
        didSet {
            setup()
        }
    }

    public override func awakeFromNib() {
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
    
    func setup() {
        self.lblTitle.text = data.title
        self.pickerDate.datePickerMode = data.datePickerMode
        self.pickerDate.setDate(data.dataValue ?? Date(), animated: true)
        self.pickerDate.isUserInteractionEnabled = data.editable

        evaluateMandatory()
    }
    
    // use this as callBack in case of failure of data check
    public func updateData(data: PickerDate) {
        self.data = data
    }
    
    @objc func handleDatePicker(_ datePicker: UIDatePicker) {
        data.dataValue = datePicker.date
        data.onDataValueUpdate?(self, data, datePicker.date)
        evaluateMandatory()
    }
    
    func evaluateMandatory() {
        if data.mandatory && data.dataValue == nil {
            self.lblTitle.textColor = .red
        } else {
            self.lblTitle.textColor = .label
        }
    }

}
