//
//  Notification.swift
//  TrackingApp
//
//  Created by tuananhdo on 22/4/24.
//

import FirebaseFirestoreInternal

enum NotificationType: Int {
    case like
    case comment
    
    var notificationMessaging : String {
        switch self {
        case .like : return "Like your post"
        case .comment : return "Comment your post"
        }
    }
}


struct Notification {
    
    var uid: String
    var postId: String
    var profileImageUrl: String = ""
    var postImageUrl: String
    var timestamp: Timestamp
    var type: NotificationType
    var fromUsername: String
    var id : String
    
    var isRead = false
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.fromUsername = dictionary["fromUsername"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
    }
    
}
