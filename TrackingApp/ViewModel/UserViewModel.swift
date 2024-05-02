//
//  UserViewModel.swift
//  TrackingApp
//
//  Created by tuananhdo on 18/4/24.
//

import Foundation
struct UserViewModel {
    private let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return user.username
    }
    
    var dateOfBirth: String {
        return user.dateOfBirth
    }
    
    var profileImage : URL? {
        return URL(string: user.profileImage)
    }
    
    var gender : String {
        return user.gender
    }
    
    var school : String {
        return user.school
    }
    
    var email :  String {
        return user.email
    }
    
    var trackingDayCount : Int {
        return user.trackingDayCount
    }
    
    init(user: User) {
        self.user = user
    }
}
