//
//  NotificationService.swift
//  TrackingApp
//
//  Created by tuananhdo on 22/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreInternal

struct NotificationService {
    
    static func uploadNotification(toUid uid: String, fromUser user :User, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "profileImageUrl": user.profileImage,
                                   "fromUsername": user.username,
                                   "type": type.rawValue,
                                   "uid": user.uid,
                                   "id" : docRef.documentID]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotification(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").order(by: "timestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let notifications = documents.map({ Notification(dictionary: $0.data()) })
            completion(notifications)
        }
    }
    
}
