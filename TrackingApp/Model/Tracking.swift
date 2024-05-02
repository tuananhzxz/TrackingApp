import Foundation
import FirebaseFirestoreInternal

struct Tracking {
    let trackingId: String
    let trackingName: String
    let trackingDescription: String
    let trackingDate: Timestamp
    let trackingTime: String
    let trackingType: String
    let trackingDay : Int
    let trackingLocation: String
    let trackingOwner: String
    let trackingOwnerEmail: String
    let trackingOwnerPhone: String
    let trackingOwnerGender: String
    let trackingOwnerSchool: String
    let trackingOwnerDateOfBirth: String
    let trackingOwnerUsername: String
    
    init(dictionary: [String: Any]) {
        self.trackingId = dictionary["trackingId"] as? String ?? ""
        self.trackingName = dictionary["trackingName"] as? String ?? ""
        self.trackingDescription = dictionary["trackingDescription"] as? String ?? ""
        self.trackingDate = dictionary["trackingDate"] as? Timestamp ?? Timestamp(date: Date())
        self.trackingTime = dictionary["trackingTime"] as? String ?? ""
        self.trackingType = dictionary["trackingType"] as? String ?? ""
        self.trackingDay = dictionary["trackingDay"] as? Int ?? 0
        self.trackingLocation = dictionary["trackingLocation"] as? String ?? ""
        self.trackingOwner = dictionary["trackingOwner"] as? String ?? ""
        self.trackingOwnerEmail = dictionary["trackingOwnerEmail"] as? String ?? ""
        self.trackingOwnerPhone = dictionary["trackingOwnerPhone"] as? String ?? ""
        self.trackingOwnerGender = dictionary["trackingOwnerGender"] as? String ?? ""
        self.trackingOwnerSchool = dictionary["trackingOwnerSchool"] as? String ?? ""
        self.trackingOwnerDateOfBirth = dictionary["trackingOwnerDateOfBirth"] as? String ?? ""
        self.trackingOwnerUsername = dictionary["trackingOwnerUsername"] as? String ?? ""
    }
}
