//
//  Constrant.swift
//  TrackingApp
//
//  Created by tuananhdo on 17/4/24.
//

import Foundation
import FirebaseFirestore

let COLLECTION_USER = Firestore.firestore().collection("users")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")
let COLLECTION_TRACKING = Firestore.firestore().collection("tracking")
