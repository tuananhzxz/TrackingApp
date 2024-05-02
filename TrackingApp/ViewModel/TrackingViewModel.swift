//
//  TrackingViewModel.swift
//  TrackingApp
//
//  Created by tuananhdo on 24/4/24.
//

import Foundation

struct TrackingViewModel {
    private let tracking: Tracking
    
    var trackingName: String {
        return tracking.trackingName
    }
    
    var trackingType: String {
        return tracking.trackingType
    }
    
    var trackingDescription: String {
        return tracking.trackingDescription
    }
    
    var trackingLocation : String {
        return tracking.trackingLocation
    }
    
    var trackingDate : String {
        let date = tracking.trackingDate.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return "Posted at:  \(dateFormatter.string(from: date))"
    }
    
    var trackingDay : Int {
        return tracking.trackingDay
    }
    
    init(tracking: Tracking) {
        self.tracking = tracking
    }
}
