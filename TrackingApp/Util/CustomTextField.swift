//
//  CustomTextField.swift
//  TrackingApp
//
//  Created by tuananhdo on 17/4/24.
//

import UIKit

class CustomTextField : UITextField {
    
    init(placeholder: String, isSecureField: Bool, isCheck : Bool) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        setDimensions(height: 50, width: frame.width - 64)
        borderStyle = isCheck ? .none : .roundedRect
        font = UIFont.systemFont(ofSize: 16)
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        textColor = isCheck ? .white : .black
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : isCheck ? UIColor(white: 1, alpha: 0.7) : UIColor(.gray)])
        isSecureTextEntry = isSecureField
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
