//
//  CommentAcessoryTextView.swift
//  TrackingApp
//
//  Created by tuananhdo on 20/4/24.
//

import UIKit

protocol CommentAcessoryTextViewDelegate : AnyObject {
    func inputTextView(_ inputTextView: CommentAcessoryTextView, wantsToUploadComment comment: String)
}

class CommentAcessoryTextView : UIView {
    
    weak var delegateNew : CommentAcessoryTextViewDelegate?
    
    // MARK: - Properties
    private var inputTextView : InputTextView = {
        let tv = InputTextView()
        tv.placeHolder = "Enter comment.."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.placeHolderShouldCenter = true
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var postButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Helper
    func configureUI() {
        autoresizingMask = .flexibleHeight
        
        backgroundColor = .white
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(inputTextView)
        inputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let driver = UIView()
        driver.backgroundColor = .lightGray
        addSubview(driver)
        driver.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.75)
    }
    
    //MARK: - Action
    @objc func handlePost() {
        self.delegateNew?.inputTextView(self, wantsToUploadComment: inputTextView.text)
    }
    
    func clearCommentTextView() {
        inputTextView.text = nil
        inputTextView.placeHoderLabel.isHidden = false
    }
    
}
