//
//  PostService.swift
//  TrackingApp
//
//  Created by tuananhdo on 19/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreInternal

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FireCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
                        "ownerImageUrl": user.profileImage,
                        "ownerUsername": user.username,
                        "ownerUid": uid] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
    
    static func fetchLikes(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FireCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
        COLLECTION_USER.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FireCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete { _ in
        COLLECTION_USER.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USER.document(uid).collection("user-likes").document(post.postId).getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
}
