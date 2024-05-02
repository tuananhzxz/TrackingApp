//
//  RegisterViewController.swift
//  TrackingApp
//
//  Created by tuananhdo on 17/4/24.
//

import UIKit

class RegisterViewController : UIViewController {
    private var viewModel = RegisterViewModel()
    private var profileImage : UIImage?
    
    private lazy var addImageBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(addImageBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let emailTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Email", isSecureField: false, isCheck: true)
        return tf
    }()
    
    private let passwordTextField : CustomTextField = {
       let tf = CustomTextField(placeholder: "Password", isSecureField: true, isCheck: true)
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    private let fullnameTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Fullname", isSecureField: false, isCheck: true)
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    private let usernameTextField : CustomTextField = {
       let tf = CustomTextField(placeholder: "Username", isSecureField: false, isCheck: true)
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    private lazy var dateOfBirthTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Date of birth", isSecureField: false, isCheck: true)
        tf.isUserInteractionEnabled = true
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datepicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        tf.inputView = datepicker
        if datepicker.isSelected {
            tf.text = formaterrDate(date: datepicker.date)
        }
        return tf
    }()
    
    private let gender : CustomTextField = {
        let tf = CustomTextField(placeholder: "Gender", isSecureField: false, isCheck: true)
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    private let school : CustomTextField = {
        let tf = CustomTextField(placeholder: "School", isSecureField: false, isCheck: true)
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    private lazy var registerBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        btn.setHeight(50)
        btn.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    private lazy var alreadyHaveAccountBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.atributeStringSet(first: "Already have an account?", last: "Log In")
        btn.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return btn
    }()
    
    private let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.keyboardDismissMode = .onDrag
        sv.isScrollEnabled = true
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        cofigureScrollView()
        configureObversedTextField()
    }
            
    //MARK: - HELPERS
    func cofigureScrollView() {
        scrollView.fillSuperview()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        let garident = CAGradientLayer()
        garident.colors = [UIColor.systemBlue.cgColor, UIColor.systemMint.cgColor]
        garident.locations = [0, 1]
        scrollView.layer.addSublayer(garident)
        garident.frame = view.frame
        
        scrollView.addSubview(addImageBtn)
        addImageBtn.centerX(inView: scrollView)
        addImageBtn.setDimensions(height: 140, width: 140)
        addImageBtn.anchor(top: scrollView.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField, dateOfBirthTextField, gender, school])
        stack.axis = .vertical
        stack.spacing = 20
        scrollView.addSubview(stack)
        stack.centerX(inView: scrollView)
        stack.anchor(top: addImageBtn.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        scrollView.addSubview(registerBtn)
        registerBtn.centerX(inView: scrollView)
        registerBtn.anchor(top: stack.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        scrollView.addSubview(alreadyHaveAccountBtn)
        alreadyHaveAccountBtn.centerX(inView: scrollView)
        alreadyHaveAccountBtn.anchor(top: registerBtn.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        }
    
    func configureObversedTextField() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        dateOfBirthTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        gender.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        school.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - Action
    @objc func addImageBtnTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateOfBirthTextField.text = formaterrDate(date: datePicker.date)
    }
    
    func formaterrDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    @objc func createUser() {
        print("DEBUG: Handle create user")
        guard let email = emailTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let password = passwordTextField.text else { return }
        guard let profileImage = self.profileImage else { return }
        guard let dateOfBirth = dateOfBirthTextField.text else { return }
        guard let gender = gender.text else { return }
        guard let school = school.text else { return }
        
        let authenCredentails = AuthenCredentails(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage, dateOfBirth : dateOfBirth, gender: gender, school: school)
        showLoader(true)
        AuthService.RegisterUser(withCredentail: authenCredentails) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Successfully register user")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func textDidChange(sender : UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else if sender == usernameTextField {
            viewModel.username = sender.text
        } else if sender == dateOfBirthTextField {
            viewModel.dateOfBirth = sender.text
        } else if sender == gender {
            viewModel.gender = sender.text
        } else {
            viewModel.school = sender.text
        }
                    
        updateForm()
    }

}

//MARK: FormModel
extension RegisterViewController : FormModel {
    func updateForm() {
        registerBtn.backgroundColor = viewModel.buttonBackgroundColor
        registerBtn.isEnabled = viewModel.formIsValid
        registerBtn.setTitleColor(viewModel.buttonTextColor, for: .normal)
    }
}

//MARK: UIImagePickerControllerDelegate
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectImage
        addImageBtn.layer.cornerRadius = addImageBtn.frame.width / 2
        addImageBtn.layer.masksToBounds = true
        addImageBtn.layer.borderWidth = 2
        addImageBtn.layer.borderColor = UIColor.white.cgColor
        addImageBtn.setImage(selectImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
    }
}

