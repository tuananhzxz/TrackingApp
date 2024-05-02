//
//  NotificationCell.swift
//  TrackingApp
//
//  Created by tuananhdo on 21/4/24.
//

import UIKit
import SDWebImage

class NotificationCell : UITableViewCell {
    
    var viewModel : NotificationViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let infoLabel : UILabel = {
        let label = UILabel()
        label.text = "Tuan Anh liked your post"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let timestampLabel : UILabel = {
        let label = UILabel()
        label.text = "2d"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.setDimensions(height: 40, width: 40)
        postImageView.centerY(inView: self, rightAnchor: rightAnchor, paddingRight: 12)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: infoLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 60)
        
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        infoLabel.attributedText = viewModel.notificationText
        postImageView.sd_setImage(with: viewModel.postImageURL)
        timestampLabel.text = viewModel.timestamp
    }
    
}
