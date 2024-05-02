//
//  UserCell.swift
//  TrackingApp
//
//  Created by tuananhdo on 19/4/24.
//

import UIKit
import SDWebImage

class UserCell : UITableViewCell {
    
    var viewModel : UserViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray
        return iv
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Tuan Anh"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let emailLabel : UILabel = {
        let label = UILabel()
        label.text = "hello@gmail.com"
        label.font = UIFont.systemFont(ofSize: 14)
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
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImage)
        nameLabel.text = viewModel.fullname
        emailLabel.text = viewModel.email
    }
    
}
