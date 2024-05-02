//
//  ProfileCell.swift
//  TrackingApp
//
//  Created by tuananhdo on 19/4/24.
//

import UIKit

class ProfileCell : UICollectionViewCell {
        
    var viewModel: UserViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let profileUIVIew: UIView = {
        let profileView = UIView()
        profileView.backgroundColor = .systemYellow
        let width = profileView.frame.size.width
        profileView.setDimensions(height: width + 360, width: width)
        profileView.layer.cornerRadius = 10
        profileView.layer.masksToBounds = true
        profileView.layer.borderWidth = 2
        profileView.layer.borderColor = UIColor.black.cgColor
        profileView.layer.shadowColor = UIColor.white.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: 2)
        profileView.layer.shadowRadius = 2
        profileView.layer.shadowOpacity = 0.5
        return profileView
    }()
    
    private var profileLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tuan Anh"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.atributeStringSet(first: "Fullname:", last: "Do Tuan Anh")
        return label
    }()
    
    private lazy var dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.atributeStringSet(first: "Date of Birth:", last: "24/04/1999")
        return label
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.atributeStringSet(first: "Gender:", last: "Male")
        return label
    }()
    
    private lazy var schoolLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.atributeStringSet(first: "School:", last: "EAUT")
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = self.atributeStringSet(first: "Email:", last: "tuananhzxz@gmail.com")
        return label
    }()
                                                      
    private lazy var totalDayOffLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.atributeStringSet(first: "Total day off:", last: "10")
        return label
    }()
    
    private lazy var totalDayOnLabel: UILabel = {
        let label = UILabel()
        label.attributedText = self.atributeStringSet(first: "Total day tracking:", last: "20")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        fullNameLabel.attributedText = self.atributeStringSet(first: "Fullname:", last: viewModel.fullname)
        nameLabel.text = viewModel.fullname
        dateOfBirthLabel.attributedText = self.atributeStringSet(first: "Date of Birth:", last: viewModel.dateOfBirth)
        genderLabel.attributedText = self.atributeStringSet(first: "Gender:", last: viewModel.gender)
        schoolLabel.attributedText = self.atributeStringSet(first: "School:", last: viewModel.school)
        emailLabel.attributedText = self.atributeStringSet(first: "Email:", last: viewModel.email)
        profileImageView.sd_setImage(with: viewModel.profileImage)
        totalDayOnLabel.attributedText = self.atributeStringSet(first: "Total day tracking:", last: "\(viewModel.trackingDayCount)")
    }
    
    func configureUI() {
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 140, width: 140)
        profileImageView.layer.cornerRadius = 140 / 2
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        addSubview(nameLabel)
        nameLabel.centerX(inView: self)
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
        let lightGray = UIView()
        lightGray.backgroundColor = .lightGray
        lightGray.alpha = 0.5
        addSubview(lightGray)
        lightGray.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, height: 1)
        
        addSubview(profileLabel)
        profileLabel.anchor(top: lightGray.bottomAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        addSubview(profileUIVIew)
        profileUIVIew.anchor(top: profileLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, emailLabel, dateOfBirthLabel ,genderLabel, schoolLabel, totalDayOffLabel, totalDayOnLabel])
        stack.axis = .vertical
        stack.spacing = 20
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top : profileUIVIew.topAnchor,left: profileUIVIew.leftAnchor,bottom: profileUIVIew.bottomAnchor, paddingTop: 16, paddingLeft: 30, paddingBottom: 32)
        
        let bottomView = UIView()
        bottomView.backgroundColor = .lightGray
        bottomView.alpha = 0.5
        addSubview(bottomView)
        bottomView.anchor(top: profileUIVIew.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, height: 1)
    }
}
