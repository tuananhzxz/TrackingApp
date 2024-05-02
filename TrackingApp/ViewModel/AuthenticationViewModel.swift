//
//  AuthenticationViewModel.swift
//  TrackingApp
//
//  Created by tuananhdo on 17/4/24.
//
import UIKit

protocol FormModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid : Bool { get }
    var buttonBackgroundColor : UIColor { get }
    var buttonTextColor : UIColor { get }
}

struct LoginViewModel : AuthenticationViewModel {
    
    var email : String?
    var password : String?
    
    var formIsValid : Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor : UIColor {
        return formIsValid ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    var buttonTextColor : UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegisterViewModel : AuthenticationViewModel {
  
    var email : String?
    var password : String?
    var fullname : String?
    var username : String?
    var dateOfBirth : String?
    var gender : String?
    var school : String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false && gender?.isEmpty == false && school?.isEmpty == false
    }
    
    var buttonBackgroundColor : UIColor {
        return formIsValid ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    var buttonTextColor : UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
}

struct EditViewModel  {
    
    private var user : User
    
    var email : String {
        return user.email
    }
    
    var fullname : String {
        return user.fullname
    }
    
    var username : String {
        return user.username
    }
    
    var dateOfBirth : String {
        return user.dateOfBirth
    }
    
    var school : String {
        return user.school
    }
    
    var gender : String {
        return user.gender
    }
    
    init(user : User) {
        self.user = user
    }
    
}

