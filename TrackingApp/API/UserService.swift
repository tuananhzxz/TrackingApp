//
//  UserService.swift
//  TrackingApp
//
//  Created by tuananhdo on 18/4/24.
//

import Foundation
import FirebaseAuth

typealias FireCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(withUid uid : String, completion: @escaping(User) -> Void) {
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
        
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USER.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let user = snapshot.documents.map({ User(dictionary: $0.data()) })
            completion(user)
        }
    }
}
