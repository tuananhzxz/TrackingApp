//
//  TrackingUploadController.swift
//  TrackingApp
//
//  Created by tuananhdo on 24/4/24.
//

import UIKit

protocol TrackingUploadControllerDelegate: AnyObject {
    func controllerDidFinishUploading(_ controller: TrackingUploadController)
}

class TrackingUploadController: UIViewController {
    
    private var isSelectingType = false
    
    weak var delegate: TrackingUploadControllerDelegate?
    
    var user : User?
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload Tracking"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private var descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let nameTextField : UITextField = {
        let textField = UITextField()
        //spacer placeholder
        let spacerView = UIView()
        spacerView.setDimensions(height: 50, width: 12)
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.attributedPlaceholder = NSAttributedString(string: "Enter title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.setDimensions(height: 50, width: 0)
        return textField
    }()
    
    private let descriptionTextView : InputTextView = {
        let textView = InputTextView()
        textView.placeHolder = "Enter description"
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.placeHolderShouldCenter = false
        return textView
    }()
    
    private let typeLabel : UILabel = {
        let label = UILabel()
        label.text = "Type"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private lazy var todoLabel : UILabel = {
        let label = UILabel()
        label.text = "To do"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 10
        label.setDimensions(height: 50, width: view.frame.width / 2 - 50)
        label.backgroundColor = .systemBlue
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTodoLabel)))
        return label
    }()

    private lazy var notToDoLabel : UILabel = {
        let label = UILabel()
        label.text = "Not to do"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 10
        label.setDimensions(height: 50, width: view.frame.width / 2 - 50)
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTodoLabel)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    //MARK: - Action
    @objc func handleTodoLabel(sender : UITapGestureRecognizer) {
        if sender.view == todoLabel {
            isSelectingType = true
            todoLabel.backgroundColor = .systemBlue
            todoLabel.textColor = .white
            notToDoLabel.backgroundColor = .white
            notToDoLabel.textColor = .black
        } else {
            isSelectingType = false
            todoLabel.backgroundColor = .white
            todoLabel.textColor = .black
            notToDoLabel.backgroundColor = .systemBlue
            notToDoLabel.textColor = .white
        }
        
    }
    
    @objc func handleUpload() {
        guard let title = nameTextField.text, !title.isEmpty else {
            print("DEBUG: Please enter title")
            return
        }
        guard let description = descriptionTextView.text, !description.isEmpty else {
            print("DEBUG: Please enter description")
            return
        }
        guard let type = isSelectingType ? notToDoLabel.text : todoLabel.text else {
            print("DEBUG: Please select type")
            return
        }
        guard let user = user else {
            print("DEBUG: User is nil")
            return
        }
        let tracking = TrackingComponent(title: title, description: description, type: type)
        showLoader(true)
        TrackingService.postTrackingWithTitleAndDescription(component: tracking, user: user) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Error upload tracking \(error.localizedDescription)")
                return
            }
            print("DEBUG: Upload tracking successfully")
        }
        delegate?.controllerDidFinishUploading(self)
    }
    
    //MARK : - Helpers
    func configureViewController() {
        view.backgroundColor = .white
        
        let rightBarButton = UIBarButtonItem(title: "Add Tracking", style: .plain, target: self, action: #selector(handleUpload))
        rightBarButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 32)
        
        view.addSubview(nameTextField)
        nameTextField.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: 32, paddingRight: 32)
        
        let bottomNameTextField = UIView()
        bottomNameTextField.backgroundColor = .lightGray
        view.addSubview(bottomNameTextField)
        bottomNameTextField.anchor(top: nameTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 3, paddingLeft : 32, paddingRight : 32, height: 0.5)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: bottomNameTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 32)
        
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: descriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingRight: 32, height: 50)
        
        let bottomDescriptionTextField = UIView()
        bottomDescriptionTextField.backgroundColor = .lightGray
        view.addSubview(bottomDescriptionTextField)
        bottomDescriptionTextField.anchor(top: descriptionTextView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft : 32, paddingRight : 32, height: 0.5)
        
        view.addSubview(typeLabel)
        typeLabel.anchor(top: bottomDescriptionTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 32)
        
        view.addSubview(todoLabel)
        todoLabel.anchor(top: typeLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 32)
        
        view.addSubview(notToDoLabel)
        notToDoLabel.anchor(top: typeLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingRight: 32)
    
    }
    
}
