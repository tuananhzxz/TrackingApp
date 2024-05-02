//
//  ImageUploader.swift
//  TrackingApp
//
//  Created by tuananhdo on 17/4/24.
//

import Foundation
import UIKit
import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(image : UIImage, completion : @escaping (String) -> Void) {
        
        guard let imgData = image.jpegData(compressionQuality: 0.8) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        ref.putData(imgData) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            ref.downloadURL { (url, error) in
                guard let imageURL = url?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
    
}
