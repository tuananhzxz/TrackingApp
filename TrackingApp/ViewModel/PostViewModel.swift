//
//  PostViewModel.swift
//  TrackingApp
//
//  Created by tuananhdo on 19/4/24.
//

import UIKit

struct PostViewModel {

    var post : Post
    
    var username : String {
        return post.ownerUsername
    }
    
    var profileImageUrl : URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var caption : String {
        return post.caption
    }
    
    var likes : Int {
        return post.likes
    }
    
    var imageUrl : URL? {
        return URL(string: post.imageUrl)
    }
    
    var timestamp : String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let timeAgo = formatter.string(from: post.timestamp.dateValue(), to: Date()) ?? ""
        return timeAgo + " ago"
    }
    
    var likeLabelText : String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    var likeButtonTintColor : UIColor {
        return post.didLike ? .red : .black
    }
    
    
    init(post: Post) {
        self.post = post
    }
    
}
