//
//  Comment.swift
//  TrackingApp
//
//  Created by tuananhdo on 20/4/24.
//

import Foundation
import FirebaseFirestoreInternal

struct Comment {
    let comment: String
    let uid: String
    let timestamp: Timestamp
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.comment = dictionary["comment"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
