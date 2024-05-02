//
//  TrackingService.swift
//  TrackingApp
//
//  Created by tuananhdo on 24/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct TrackingComponent {
    let title : String
    let description : String
    let type : String
}

struct TrackingService {
    
    static func postTrackingWithTitleAndDescription(component : TrackingComponent ,user : User, completion: @escaping(FireCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData : [String : Any] = [
                                        "uid" : uid,
                                        "fullname" : user.fullname,
                                        "username" : user.username,
                                        "dateOfBirth" : user.dateOfBirth,
                                        "trackingDate": Timestamp(date: Date()),
                                        "trackingName" : component.title,
                                        "trackingType" : component.type,
                                        "trackingDescription" : component.description]
        COLLECTION_TRACKING.addDocument(data: docData, completion: completion)
    }
    
    static func fetchTracking(forUser user : User,completion: @escaping([Tracking]) -> Void) {
        COLLECTION_TRACKING.whereField("uid", isEqualTo: user.uid).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let tracking = documents.map({ Tracking(dictionary: $0.data()) })
            completion(tracking)
        }
    }
    
    static func resetIsCheckedPassed(forUser user : User, completion : @escaping(FireCompletion)) {
        COLLECTION_USER.document(user.uid).updateData(["isCheckedPassed" : false], completion: completion)
    }
    
    static func incrementTrackingDayCount(forUser user : User, completion : @escaping(FireCompletion)) {
        // increment tracking day count and save trackingDay
        let calender = Calendar.current
        let date = Date()
        let day = calender.component(.day, from: date)
        COLLECTION_USER.document(user.uid).updateData(["trackingDay" : day, "trackingDayCount" : user.trackingDayCount + 1], completion: completion)
    }
    
    static func checkIfTodayClickedButton(forUser uid : String, completion : @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let calender = Calendar.current
        let date = Date()
        let day = calender.component(.day, from: date)
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            guard let trackingDay = snapshot?.data()?["trackingDay"] as? Int else { return }
            completion(day == trackingDay)
        }
    }
    
}
