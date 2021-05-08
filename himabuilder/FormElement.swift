//
//  FormElement.swift
//  Mambu
//
//  Created by Francesco Cosenza on 14/04/21.
//  Copyright © 2021 Francesco Cosenza. All rights reserved.
//

import Foundation
import UIKit

enum FormElement {
    case linearSelect(LinearSelect)
    case push(Push)
    case text(Text)
    case textarea(TextArea)
    case label(Label)
    case button(Button)
    
    static var nibNames: [String] {
        return [LinearSelect.nibName, Text.nibName, TextArea.nibName, Label.nibName, Push.nibName, Button.nibName]
    }
}

protocol NibFormElement {
    static var nibName: String { get }
}

class BaseFormElement {
    var title: String?
    var subtitle: String?
    var value: String?
    var mandatory: Bool = false
    var enable: Bool = true
    
    typealias OnValueUpdate = ((BaseFormElement, String?) -> Void)
    typealias OnClick = ((BaseFormElement, UIView?) -> Void)
    
    var onValueUpdate: OnValueUpdate?
    var onClick: OnClick?
    
    convenience init(title: String, value: String?, onValueUpdate: OnValueUpdate?, onClick: OnClick?) {
        self.init()
        self.title = title
        self.value = value
        self.onValueUpdate = onValueUpdate
        self.onClick = onClick
    }
    
    convenience init(title: String, value: String?, onValueUpdate: OnValueUpdate?) {
        self.init(title: title, value: value, onValueUpdate: onValueUpdate, onClick: nil)
    }
    convenience init(title: String, value: String?, onClick: OnClick?) {
        self.init(title: title, value: value, onValueUpdate: nil, onClick: onClick)
    }
}

protocol GenericRepresentable {
    var _id: String { get }
    var _title: String { get }
    var _subtitle: String? { get }
    var _isSelected: Bool? { get set }

}

extension GenericRepresentable {    
    var _subtitle: String? {
        return nil
    }
    var _isSelected: Bool? {
        get {
            return false
        }
        set(newValue) {
        }
    }
}

class LinearSelect: BaseFormElement, NibFormElement {
    static var nibName: String = "LinearSelectCollectionCell"
    var values: [GenericRepresentable] = []
    var multipleValues: Bool = false
    
    convenience init(title: String, value: String?, values: [GenericRepresentable], multipleValues: Bool = false, onClick: OnClick?) {
        self.init(title: title, value: value, onValueUpdate: nil, onClick: onClick)
        self.multipleValues = multipleValues
        self.values = values
    }
}

class Button: BaseFormElement, NibFormElement {
    static var nibName: String = "ButtonCollectionCell"
    var height: CGFloat = 60.0

    convenience init(title: String, value: String?, height: CGFloat, onClick: OnClick?) {
        self.init(title: title, value: value, onValueUpdate: nil, onClick: onClick)
        self.height = height
    }
}

class Push: BaseFormElement, NibFormElement {
    static var nibName: String = "PushCollectionCell"
    
    convenience init(title: String, value: String?, onClick: OnClick?) {
        self.init(title: title, value: value, onValueUpdate: nil, onClick: onClick)
    }
}

class Text: BaseFormElement, NibFormElement {
    static var nibName: String = "TextCollectionCell"
}

class TextArea: BaseFormElement, NibFormElement {
    static var nibName: String = "TextAreaCollectionCell"
}

class Label: BaseFormElement, NibFormElement {
    static var nibName: String = "LabelCollectionCell"
    var height: CGFloat = 40.0
    
    convenience init(title: String, value: String?, height: CGFloat, onClick: OnClick?) {
        self.init(title: title, value: value, onValueUpdate: nil, onClick: onClick)
        self.height = height
    }
}

extension UICollectionView {
    func registerFormCell() {
//        self.backgroundColor = .blue
        FormElement.nibNames.forEach( {
            self.register(UINib(nibName: $0, bundle: .main), forCellWithReuseIdentifier: $0)
        })        
    }
    
    func linearSelectCell(_ data: LinearSelect, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: LinearSelect.nibName, for: indexPath)
        guard let formCell = cell as? LinearSelectCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
        formCell.addBorders([.full])
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
//        formCell.addBorders([.bottom])
//        formCell.addBorders([.customRight(BorderData(width: 5, color: .red)), .customLeft(BorderData(width: 5, color: .red))])
        return formCell
    }
    
    func pushCell(_ data: Push, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: Push.nibName, for: indexPath)
        guard let formCell = cell as? PushCollectionCell else {
            return UICollectionViewCell()
        }
        formCell.data = data
//        formCell.addBorders([.bottom])
//        formCell.addBorders([.customRight(BorderData(width: 5, color: .red)), .customLeft(BorderData(width: 5, color: .red))])
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
    
    func formElementListCell(_ element: FormElement, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch element {
        case .linearSelect(let data):
            return linearSelectCell(data, cellForItemAt: indexPath)
        case .text(let data):
            return textCell(data, cellForItemAt: indexPath)
        case .textarea(let data):
            return textAreaCell(data, cellForItemAt: indexPath)
        case .label(let data):
            return labelCell(data, cellForItemAt: indexPath)
        case .push(let data):
            return pushCell(data, cellForItemAt: indexPath)
        case .button(let data):
            return buttonCell(data, cellForItemAt: indexPath)
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
    }
    
}
