//
//  InputTextView.swift
//  TrackingApp
//
//  Created by tuananhdo on 19/4/24.
//

import UIKit

class InputTextView : UITextView {
    
    var placeHolder : String? {
        didSet { placeHoderLabel.text = placeHolder }
    }
    
    let placeHoderLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        return lb
    }()
    
    var placeHolderShouldCenter = true {
        didSet {
            if placeHolderShouldCenter {
                placeHoderLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 8)
                placeHoderLabel.centerY(inView: self)
            } else {
                placeHoderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 8)
            }
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHoderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlaceHolderHide), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePlaceHolderHide() {
        placeHoderLabel.isHidden = !text.isEmpty
    }
    
    
}
