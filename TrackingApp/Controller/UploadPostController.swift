//
//  UploadPostController.swift
//  TrackingApp
//
//  Created by tuananhdo on 19/4/24.
//

import UIKit

protocol UploadPostControllerDelegate : AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController : UIViewController {
    
    var selectedImage : UIImage? {
        didSet {
            postImageView.image = selectedImage
        }
    }
    
    private var user : User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate : UploadPostControllerDelegate?
    
    private let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private lazy var captionTextView : InputTextView = {
        let textView = InputTextView()
        textView.placeHolderShouldCenter = false
        textView.placeHolder = "Enter caption..."
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    private let characterCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "0/100"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleShare))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        configureUI()
    }

    //MARK: - Helper
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(postImageView)
        postImageView.setDimensions(height: 200, width: 200)
        postImageView.centerX(inView: view)
        postImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: postImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        characterCountLabel.text = captionTextView.text.count.description + "/100"
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingBottom: -8, paddingRight: 12)
    }
    
    //MARK: - Action
    @objc func handleShare() {
        guard let image = postImageView.image else { return }
        showLoader(true)
        PostService.uploadPost(caption: captionTextView.text, image: image, user: user) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Error uploading post \(error.localizedDescription)")
                return
            }
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
}

//MARK: - UITextViewDelegate
extension UploadPostController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
