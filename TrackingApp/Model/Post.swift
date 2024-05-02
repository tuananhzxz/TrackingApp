//
//  Post.swift
//  TrackingApp
//
//  Created by tuananhdo on 19/4/24.
//

import Foundation
import FirebaseFirestoreInternal

struct Post {
    var caption: String
    var likes: Int
    var imageUrl: String
    var ownerUid: String
    var timestamp: Timestamp
    var ownerImageUrl: String
    var ownerUsername: String
    var postId: String
    var didLike = false
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
