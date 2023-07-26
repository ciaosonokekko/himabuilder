//
//  FormElement.swift
//  Mambu
//
//  Created by Francesco Cosenza on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import Foundation
import UIKit

public enum OrientationType {
    case standard
    case vertical
    case horizontal
}

public enum FormElement {
    case linearSelect(LinearSelect)
    case text(Text)
    case textarea(TextArea)
    case label(Label)
    case button(Button)
    case check(Check)
    case checkWithSubtitle(Check)
    case pickerDate(PickerDate)
    
    static var nibNames: [String] {
        return [LinearSelect.nibName, Text.nibName, TextArea.nibName, Label.nibName, Label.nibName2, Button.nibName, Check.nibName, PickerDate.nibName]
    }
    
    public var hidden: Bool {
        switch(self) {
        case .linearSelect(let element): return element.hidden
        case .text(let element): return element.hidden
        case .textarea(let element): return element.hidden
        case .label(let element): return element.hidden
        case .button(let element): return element.hidden
        case .check(let element): return element.hidden
        case .checkWithSubtitle(let element): return element.hidden
        case .pickerDate(let element): return element.hidden
        }
    }
    
    public var height: CGFloat {
        switch(self) {
        case .textarea(_): return hidden ? 0 : 120
        case .label(let label): return hidden ? 0 : (label.orientation == .vertical ? 60 : 44)
        case .checkWithSubtitle(let check): return check.hasExtraTextField ? 100 : 70
        default: return hidden ? 0 : 44
        }
    }
}

public protocol NibFormElement {
    static var nibName: String { get }
}

open class BaseFormElement {
    open var title: String?
    open var subtitle: String?
    open var hasExtraTextField: Bool = false
    open var value: String?
    open var mandatory: Bool = false
    open var hidden: Bool = false
    open var enable: Bool = true
    open var editable: Bool = true
    open var orientation: OrientationType = .standard
    open var keyboardType: UIKeyboardType = .default
    
    public typealias OnValueUpdate = ((BaseFormElement, String?) -> Void)
    public typealias OnClick = ((BaseFormElement, UIView?) -> Void)
    public typealias OnEndEditing = ((UICollectionViewCell, BaseFormElement, String?) -> Void)
    
    var onEndEditing: OnEndEditing?
    var onValueUpdate: OnValueUpdate?
    var onExtraValueUpdate: OnValueUpdate?
    var onClick: OnClick?
    
    public convenience init(title: String, value: String? = nil, mandatory: Bool = false, orientation: OrientationType = .standard, keyboardType: UIKeyboardType = .default, hidden: Bool = false, onValueUpdate: OnValueUpdate? = nil, onClick: OnClick? = nil, onEndEditing: OnEndEditing? = nil, editable: Bool = true, subtitle: String? = nil, extraTextField: Bool = false) {
        self.init()
        self.title = title
        self.value = value
        self.mandatory = mandatory
        self.orientation = orientation
        self.keyboardType = keyboardType
        self.hidden = hidden
        self.onValueUpdate = onValueUpdate
        self.onClick = onClick
        self.onEndEditing = onEndEditing
        self.editable = editable
        self.subtitle = subtitle
        self.hasExtraTextField = extraTextField
    }
    
    public convenience init(title: String, value: String?) {
        self.init(title: title, value: value, onValueUpdate: nil, onClick: nil)
    }
    
    public convenience init(title: String, value: String?, onValueUpdate: OnValueUpdate?) {
        self.init(title: title, value: value, onValueUpdate: onValueUpdate, onClick: nil)
    }
    
    public convenience init(title: String, value: String?, onClick: OnClick?) {
        self.init(title: title, value: value, onValueUpdate: nil, onClick: onClick)
    }
}

public protocol GenericRepresentable {
    var _id: String { get }
    var _title: String { get }
    var _subtitle: String? { get }
    var _isSelected: Bool? { get set }
}

public extension GenericRepresentable {
    var _subtitle: String? {
        return nil
    }
    
    var _isSelected: Bool? {
        get {
            return false
        }
        set(newValue) { }
    }
}

public extension GenericRepresentable {
    static func == (lhs: GenericRepresentable, rhs: GenericRepresentable) -> Bool {
        lhs._id == rhs._id
    }
}

public class GenericRepresentableStringContainer: GenericRepresentable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    public var _id: String {
        value
    }
    
    public var _title: String {
        value
    }
}

open class LinearSelect: BaseFormElement, NibFormElement {
    public static var nibName: String = "LinearSelectCollectionCell"
    open var values: [GenericRepresentable] = []
    open var selectedValues: [GenericRepresentable] = []
    open var multipleValues: Bool = false
    
    public convenience init(title: String, value: String?, values: [GenericRepresentable], selectedValues: [GenericRepresentable] = [], mandatory: Bool = false, hidden: Bool = false, multipleValues: Bool = false, onClick: OnClick?) {
        self.init(title: title, value: value, mandatory: mandatory, hidden: hidden, onValueUpdate: nil, onClick: onClick)
        self.multipleValues = multipleValues
        self.values = values
        self.selectedValues = selectedValues
    }
}

open class Button: BaseFormElement, NibFormElement {
    static public var nibName: String = "ButtonCollectionCell"
    open var height: CGFloat = 60.0
    open var btnColor: UIColor = .systemBlue
    
    public convenience init(title: String, value: String? = nil, height: CGFloat = 60, btnColor: UIColor = .systemBlue, onClick: OnClick?) {
        self.init(title: title, value: value, onValueUpdate: nil, onClick: onClick)
        self.height = height
        self.btnColor = btnColor
    }
}

open class Check: BaseFormElement, NibFormElement {
    static public var nibName: String = "CheckCollectionCell"
    static public var nibName2: String = "CheckLeftSubtitleCollectionCell"
    
    var extraValue: String?

    public convenience init(title: String, value: String? = nil, onValueUpdate: OnValueUpdate?, subtitle: String? = nil, extraTextField: Bool = false, extraValue: String?) {
        self.init(title: title, value: value, onValueUpdate: onValueUpdate, onClick: nil, subtitle: subtitle, extraTextField: extraTextField)
        self.extraValue = extraValue
    }
}

public enum TextType {
    case standard
    case date
    case integer
    case decimal
    case readonly
}

open class Text: BaseFormElement, NibFormElement {
    public static var nibName: String = "TextCollectionCell"
    var textType: TextType = .standard
    var suggestions: [String] = []
    var buttonIcon: UIImage?
    
    public convenience init(
        title: String,
        value: String?,
        mandatory: Bool = false,
        hidden: Bool = false,
        textType: TextType = .standard,
        suggestions: [String] = [],
        buttonIcon: UIImage? = nil,
        onValueUpdate: OnValueUpdate? = nil,
        onEndEditing: OnEndEditing? = nil,
        onClick: OnClick? = nil,
        editable: Bool = true
        
    ) {
        self.init(title: title, value: value, mandatory: mandatory, hidden: hidden, onValueUpdate: onValueUpdate, onClick: onClick, onEndEditing: onEndEditing, editable: editable)
        self.textType = textType
        self.suggestions = suggestions
        self.buttonIcon = buttonIcon
    }
}

open class TextArea: BaseFormElement, NibFormElement {
    public static var nibName: String = "TextAreaCollectionCell"
}

open class Label: BaseFormElement, NibFormElement {
    public static var nibName: String = "LabelCollectionCell"
    public static var nibName2: String = "LabelVerticalCollectionCell"
    var buttonIcon: UIImage?
    var onButtonIconClick: OnClick?

    
    public convenience init(title: String, value: String?, buttonIcon: UIImage? = nil, onClick: OnClick? = nil, onButtonIconClick: OnClick? = nil, orientation: OrientationType = .standard) {
        self.init(title: title, value: value, orientation: orientation, onValueUpdate: nil, onClick: onClick)
        self.buttonIcon = buttonIcon
        self.onButtonIconClick = onButtonIconClick
    }
}

open class PickerDate: BaseFormElement, NibFormElement {
    public static var nibName: String = "DatePickerCollectionCell"
    public typealias OnDataValueUpdate = ((UICollectionViewCell, BaseFormElement, Date) -> Void)
    
    var dataValue: Date?
    var onDataValueUpdate: OnDataValueUpdate?
    var datePickerMode: UIDatePicker.Mode = .dateAndTime
    
    public convenience init(title: String, value: Date?, mandatory: Bool = false, hidden: Bool = false, datePickerMode: UIDatePicker.Mode = .dateAndTime, onDataValueUpdate: OnDataValueUpdate?) {
        self.init(title: title, value: nil, mandatory: mandatory, hidden: hidden)
        self.onDataValueUpdate = onDataValueUpdate
        self.dataValue = value
        self.datePickerMode = datePickerMode
    }    
}

public extension UICollectionView {
    func registerFormCell() {
//        self.backgroundColor = .blue
        
        self.register(UINib(nibName: LinearSelect.nibName, bundle: Bundle(for: LinearSelectCollectionCell.self)), forCellWithReuseIdentifier: LinearSelect.nibName)
        self.register(UINib(nibName: Button.nibName, bundle: Bundle(for: ButtonCollectionCell.self)), forCellWithReuseIdentifier: Button.nibName)
        self.register(UINib(nibName: Check.nibName, bundle: Bundle(for: CheckCollectionCell.self)), forCellWithReuseIdentifier: Check.nibName)
        self.register(UINib(nibName: Check.nibName2, bundle: Bundle(for: CheckLeftSubtitleCollectionCell.self)), forCellWithReuseIdentifier: Check.nibName2)
        self.register(UINib(nibName: Label.nibName, bundle: Bundle(for: LabelCollectionCell.self)), forCellWithReuseIdentifier: Label.nibName)
        self.register(UINib(nibName: Label.nibName2, bundle: Bundle(for: LabelVerticalCollectionCell.self)), forCellWithReuseIdentifier: Label.nibName2)
        self.register(UINib(nibName: TextArea.nibName, bundle: Bundle(for: TextAreaCollectionCell.self)), forCellWithReuseIdentifier: TextArea.nibName)
        self.register(UINib(nibName: Text.nibName, bundle: Bundle(for: TextCollectionCell.self)), forCellWithReuseIdentifier: Text.nibName)
        self.register(UINib(nibName: PickerDate.nibName, bundle: Bundle(for: DatePickerCollectionCell.self)), forCellWithReuseIdentifier: PickerDate.nibName)

        
//        FormElement.nibNames.forEach( {
//            self.register(UINib(nibName: $0, bundle: .main), forCellWithReuseIdentifier: $0)
//        })
    }
    
    func linearSelectCell(_ data: LinearSelect, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: LinearSelect.nibName, for: indexPath)
        guard let formCell = cell as? LinearSelectCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.bottom])
        return formCell
    }
    
    func textCell(_ data: Text, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: Text.nibName, for: indexPath)
        guard let formCell = cell as? TextCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.bottom])
        return formCell
    }
    
    func textAreaCell(_ data: TextArea, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: TextArea.nibName, for: indexPath)
        guard let formCell = cell as? TextAreaCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.bottom])
        return formCell
    }
    
    func labelCell(_ data: Label, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: Label.nibName, for: indexPath)
        guard let formCell = cell as? LabelCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.bottom])
        return formCell
    }
    
    func labelVerticalCell(_ data: Label, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: Label.nibName2, for: indexPath)
        guard let formCell = cell as? LabelVerticalCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.bottom])
        return formCell
    }
    
    func buttonCell(_ data: Button, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: Button.nibName, for: indexPath)
        guard let formCell = cell as? ButtonCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
//        formCell.addBorders([.bottom])
//        formCell.addBorders([.customRight(BorderData(width: 5, color: .red)), .customLeft(BorderData(width: 5, color: .red))])
        return formCell
    }
    
    func checkCell(_ data: Check, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: Check.nibName, for: indexPath)
        guard let formCell = cell as? CheckCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.bottom])
        return formCell
    }
    
    func checkCellWithSubtitle(_ data: Check, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: Check.nibName2, for: indexPath)
        guard let formCell = cell as? CheckLeftSubtitleCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.bottom])
        return formCell
    }
    
    func pickerDateCell(_ data: PickerDate, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: PickerDate.nibName, for: indexPath)
        guard let formCell = cell as? DatePickerCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.bottom])
        return formCell
    }
    
    func formElementListCell(_ element: FormElement, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch element {
        case .linearSelect(let data):
            return linearSelectCell(data, cellForItemAt: indexPath)
        case .text(let data):
            return textCell(data, cellForItemAt: indexPath)
        case .textarea(let data):
            return textAreaCell(data, cellForItemAt: indexPath)
        case .label(let data):
            switch(data.orientation) {
            case .vertical:
                return labelVerticalCell(data, cellForItemAt: indexPath)
            default:
                return labelCell(data, cellForItemAt: indexPath)
            }
        case .button(let data):
            return buttonCell(data, cellForItemAt: indexPath)
        case .check(let data):
            return checkCell(data, cellForItemAt: indexPath)
        case .checkWithSubtitle(let data):
            return checkCellWithSubtitle(data, cellForItemAt: indexPath)
        case .pickerDate(let data):
            return pickerDateCell(data, cellForItemAt: indexPath)
        }
    }
}

extension UIView {
    
    struct BorderData {
        let width: CGFloat
        let color: UIColor
    }
    
    var defaultBorderData: BorderData {
        return BorderData(width: 0.6, color: .secondaryLabel)
    }
    
    enum BorderType {
        case top
        case right
        case bottom
        case left
        case full
        
        case customTop(BorderData)
        case customRight(BorderData)
        case customBottom(BorderData)
        case customLeft(BorderData)
        case customFull(BorderData)
    }
    
    func addBorders(_ borders: [BorderType]) {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        for border in borders {
            switch border {
            case .top:
                addBorder(frame: CGRect(x: 0, y: 0, width: width, height: defaultBorderData.width), color: defaultBorderData.color)
                break
            case .customTop(let data):
                addBorder(frame: CGRect(x: 0, y: 0, width: width, height: data.width), color: data.color)
                break
                
            case .right:
                addBorder(frame: CGRect(x: width - defaultBorderData.width, y: 0, width: defaultBorderData.width, height: height), color: defaultBorderData.color)
                break
            case .customRight(let data):
                addBorder(frame: CGRect(x: width - data.width, y: 0, width: data.width, height: height), color: data.color)
                break
                
            case .bottom:
                addBorder(frame: CGRect(x: 0, y: height - defaultBorderData.width, width: width, height: defaultBorderData.width), color: defaultBorderData.color)
                break
            case .customBottom(let data):
                addBorder(frame: CGRect(x: 0, y: height - data.width, width: width, height: data.width), color: data.color)
                break
                
            case .left:
                addBorder(frame: CGRect(x: 0, y: 0, width: defaultBorderData.width, height: height), color: defaultBorderData.color)
                break
            case .customLeft(let data):
                addBorder(frame: CGRect(x: 0, y: 0, width: data.width, height: height), color: data.color)
                break
                
            case .full:
                addBorder(frame: CGRect(x: 0, y: 0, width: width, height: defaultBorderData.width), color: defaultBorderData.color)
                addBorder(frame: CGRect(x: width - defaultBorderData.width, y: 0, width: defaultBorderData.width, height: height), color: defaultBorderData.color)
                addBorder(frame: CGRect(x: 0, y: height - defaultBorderData.width, width: width, height: defaultBorderData.width), color: defaultBorderData.color)
                addBorder(frame: CGRect(x: 0, y: 0, width: defaultBorderData.width, height: height), color: defaultBorderData.color)
                break
            case .customFull(let data):
                addBorder(frame: CGRect(x: 0, y: 0, width: width, height: data.width), color: data.color)
                addBorder(frame: CGRect(x: width - data.width, y: 0, width: data.width, height: height), color: data.color)
                addBorder(frame: CGRect(x: 0, y: height - data.width, width: width, height: data.width), color: data.color)
                addBorder(frame: CGRect(x: 0, y: 0, width: data.width, height: height), color: data.color)
                break
            }
        }
    }
    
    fileprivate func addBorder(frame: CGRect, color: UIColor) {
        let border = UIView(frame: frame)
        border.backgroundColor = color
        self.addSubview(border)
        self.bringSubviewToFront(border)
        
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            border.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
