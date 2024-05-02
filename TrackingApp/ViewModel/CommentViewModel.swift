//
//  CommentViewModel.swift
//  TrackingApp
//
//  Created by tuananhdo on 20/4/24.
//

import UIKit

struct CommentViewModel {
    let comment: Comment
    
    var profileImageUrl: URL? {
        return URL(string: comment.profileImageUrl)
    }
        
    var username : NSAttributedString {
        let atributeString = NSMutableAttributedString(string: "\(comment.username) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        atributeString.append(NSAttributedString(string: comment.comment, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        return atributeString
    }
    
    var commentText: String {
        return comment.comment
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let timeAgo = formatter.string(from: comment.timestamp.dateValue(), to: Date()) ?? ""
        return timeAgo + " ago"
    }
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.comment
        label.lineBreakMode = .byWordWrapping
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
