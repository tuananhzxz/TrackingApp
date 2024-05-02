//
//  User.swift
//  TrackingApp
//
//  Created by tuananhdo on 17/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

struct User {
    var email : String
    var fullname : String
    var username : String
    var dateOfBirth : String
    var gender : String
    var school : String
    var profileImage : String
    var trackingDayCount : Int
    var trackingDay : Int = 0
    var uid : String
    var isCheckedToday : Bool = false
    
    var isCurrentUser : Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary : [String : Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.dateOfBirth = dictionary["dateOfBirth"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.school = dictionary["school"] as? String ?? ""
        self.profileImage = dictionary["profileImgUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.trackingDayCount = dictionary["trackingDayCount"] as? Int ?? 0
    }
}
