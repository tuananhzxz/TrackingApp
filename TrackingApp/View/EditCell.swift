//
//  EditCell.swift
//  TrackingApp
//
//  Created by tuananhdo on 23/4/24.
//

import UIKit

protocol EditCellDelegate : AnyObject {
    func handleUpdateProfile()
}

class EditCell : UICollectionViewCell {
    
    var viewModel : EditViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate : EditCellDelegate?
    
    private let fullNameTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Fullname", isSecureField: false, isCheck: false)
        return tf
    }()
    
    private let usernameTextField : CustomTextField = {
       let tf = CustomTextField(placeholder: "Username", isSecureField: false, isCheck: false)
        return tf
    }()
    
    private let emailTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Username", isSecureField: false, isCheck: false)
        return tf
    }()
    
    private lazy var dateOfBirthTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Date of birth", isSecureField: false, isCheck: false)
        tf.isUserInteractionEnabled = true
        tf.placeholder = "Date of birth"
        tf.borderStyle = .roundedRect
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
    
    private let genderTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Gender", isSecureField: false, isCheck: false)
        return tf
    }()
    
    private lazy var changeProfileBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Profile", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.systemBlue
        btn.addTarget(self, action: #selector(handleChangeProfile), for: .touchUpInside)
        btn.setHeight(50)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    private let schoolTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "School", isSecureField: false, isCheck: false)
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func configureCollectionViewCell() {
        backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [fullNameTextField, usernameTextField, emailTextField, dateOfBirthTextField, genderTextField, schoolTextField, changeProfileBtn])
        stack.axis = .vertical
        stack.spacing = 20
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        emailTextField.text = viewModel.email
        fullNameTextField.text = viewModel.fullname
        usernameTextField.text = viewModel.username
        dateOfBirthTextField.text = viewModel.dateOfBirth
        genderTextField.text = viewModel.gender
        schoolTextField.text = viewModel.school
    }
    
    //MARK: - Action
    @objc func dateChange(datePicker: UIDatePicker) {
        dateOfBirthTextField.text = formaterrDate(date: datePicker.date)
    }
    
    func formaterrDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    @objc func handleChangeProfile() {
        print("DEBUG: Handle change profile")
        guard let email = emailTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let dateOfBirth = dateOfBirthTextField.text else { return }
        guard let gender = genderTextField.text else { return }
        guard let school = schoolTextField.text else { return }
        
        let editCredentails = EditCredentails(email: email, fullname: fullname, username: username, dateOfBirth: dateOfBirth, gender: gender, school: school)
        showLoader(true)
        AuthService.editProfile(withCredentail: editCredentails) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Error is \(error)")
                return
            }
            print("DEBUG: Success")
            self.makeAlert(title: "Successfull", message: "Your profile has been updated")
        }
        delegate?.handleUpdateProfile()
    }

}
