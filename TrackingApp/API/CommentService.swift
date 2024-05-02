//
//  CommentService.swift
//  TrackingApp
//
//  Created by tuananhdo on 20/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreInternal

struct CommentService {
    
    static func uploadComment(comment: String, postId: String, user : User, completion: @escaping(FireCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = ["comment" : comment,
                    "timestamp": Timestamp(date: Date()),
                    "profileImageUrl" : user.profileImage,
                    "username" : user.username,
                    "uid": uid] as [String : Any
        ]
        
        COLLECTION_POSTS.document(postId).collection("comments").addDocument(data: data, completion: completion)
    }
    
    static func fetchComments(postId: String, completion: @escaping([Comment]) -> Void) {
        COLLECTION_POSTS.document(postId).collection("comments").order(by: "timestamp").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let comments = documents.map({ Comment(dictionary: $0.data()) })
            completion(comments)
        }
    }
    
}
