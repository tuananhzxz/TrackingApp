//
//  LoginViewController.swift
//  TrackingApp
//
//  Created by tuananhdo on 17/4/24.
//

import UIKit

protocol AuthenticationDelegate : AnyObject {
    func authenticationComplete()
    func authenticationDidComplete(_ controller: LoginViewController)
}

class LoginViewController : UIViewController {
    
    private var viewModel = LoginViewModel()
    
    weak var delegate : AuthenticationDelegate?
    
    private let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "tracking")
        return iv
    }()
    
    private let emailTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Email", isSecureField: false, isCheck: true)
        return tf
    }()
    
    private let passwordTextField : CustomTextField = {
       let tf = CustomTextField(placeholder: "Password", isSecureField: true, isCheck: true)
        return tf
    }()
    
    private lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        btn.setHeight(50)
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    private lazy var dontHaveAccountBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.atributeStringSet(first: "Don't have an account?", last: "Sign up")
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return btn
    }()
    
    private lazy var forgotPasswordBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.atributeStringSet(first: "Forgot your password?", last: "Get help signing in")
        return btn
    }()
    
    //MARK: - Action
    @objc func handleShowSignUp() {
        let controller = RegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender : UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        updateForm()
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        showLoader(true)
        AuthService.LoginUser(withEmail: email, password: password) { result, error in
            self.showLoader(false)
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
                return
            }
            
            self.delegate?.authenticationComplete()
            self.delegate?.authenticationDidComplete(self)
        }
    }
    
    func alertMessage(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureObeverseTextField()
    }
    //MARK: - Helper
    func configureViewController() {
        configureGradientLayer()
        
        view.addSubview(imageView)
        imageView.setDimensions(height: 200, width: 180)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 48, paddingRight: 48)
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 48, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(passwordTextField)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(loginBtn)
        loginBtn.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(forgotPasswordBtn)
        forgotPasswordBtn.anchor(top: loginBtn.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(dontHaveAccountBtn)
        dontHaveAccountBtn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 24, paddingRight: 24)
    }
    
    func configureObeverseTextField(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}

//MARK: - FormModel
extension LoginViewController : FormModel {
    func updateForm() {
        loginBtn.backgroundColor = viewModel.buttonBackgroundColor
        loginBtn.isEnabled = viewModel.formIsValid
        loginBtn.setTitleColor(viewModel.buttonTextColor, for: .normal)
    }
}
