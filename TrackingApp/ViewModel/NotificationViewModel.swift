//
//  NotificationViewModel.swift
//  TrackingApp
//
//  Created by tuananhdo on 22/4/24.
//

import UIKit

struct NotificationViewModel {
    
    private let notification: Notification
    
    var profileImageURL: URL? {
        return URL(string: notification.profileImageUrl)
    }
    
    var postImageURL: URL? {
        return URL(string: notification.postImageUrl)
    }
    
    var notificationText : NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(notification.fromUsername) ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        )
        return attributedString
    }
    
    var notificationMessage: String {
        return notification.type.notificationMessaging
    }
    
    var timestamp: String {
        let date = notification.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    var isRead: Bool {
        return notification.isRead
    }
    
    init(notification: Notification) {
        self.notification = notification
    }
}
