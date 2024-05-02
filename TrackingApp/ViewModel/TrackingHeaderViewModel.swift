//
//  TrackingHeaderViewModel.swift
//  TrackingApp
//
//  Created by tuananhdo on 26/4/24.
//

import UIKit

struct TrackingHeaderViewModel {
    
    let user : User
    
    var trackingButtonText : String {
        return user.isCheckedToday ? "Tracking" : "Tracked"
    }
    
    var trackingButtonColor : UIColor {
        return user.isCheckedToday ? .systemBlue : .systemGray
    }
    
    var trackingButtonTextColor : UIColor {
        return user.isCheckedToday ? .white : .black
    }
    
    var trackingIsEnabled : Bool {
        return !user.isCheckedToday
    }
    
    init(user: User) {
        self.user = user
    }
    
}
