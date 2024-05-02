//
//  AuthService.swift
//  TrackingApp
//
//  Created by tuananhdo on 17/4/24.
//

import UIKit
import FirebaseAuth

struct AuthenCredentails {
    var email : String
    var password : String
    var fullname : String
    var username : String
    var profileImage : UIImage
    var dateOfBirth : String
    var gender : String
    var school : String
}

struct EditCredentails {
    var email : String
    var fullname : String
    var username : String
    var dateOfBirth : String
    var gender : String
    var school : String
}

struct AuthService {
    
    static func LoginUser(withEmail email : String, password : String, completion : @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func RegisterUser(withCredentail credentail : AuthenCredentails, completion : @escaping(Error?) -> Void) {
        ImageUploader.uploadImage(image: credentail.profileImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: credentail.email, password: credentail.password) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data : [String : Any] = ["email" : credentail.email,
                                             "fullname" : credentail.fullname,
                                             "username" : credentail.username,
                                             "profileImgUrl" : imageUrl,
                                             "uid" : uid,
                                             "dateOfBirth" : credentail.dateOfBirth,
                                             "gender" : credentail.gender,
                                             "school" : credentail.school
                ]
                
                COLLECTION_USER.document(uid).setData(data, completion: completion)
            }
            
        }
    }
    
    static func editProfile(withCredentail credentail : EditCredentails, completion : @escaping(Error?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let data : [String : Any] = ["email" : credentail.email,
                                         "fullname" : credentail.fullname,
                                         "username" : credentail.username,
                                         "uid" : uid,
                                         "dateOfBirth" : credentail.dateOfBirth,
                                         "school" : credentail.school,
                                         "gender" : credentail.gender]
            
            COLLECTION_USER.document(uid).updateData(data, completion: completion)
        }
    
    static func fetchProfile(completion : @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            let user = User(dictionary: data)
            completion(user)
        }
    }
}
