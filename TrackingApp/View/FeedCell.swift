//
//  FeedCell.swift
//  TrackingApp
//
//  Created by tuananhdo on 16/4/24.
//

import UIKit
import SDWebImage

protocol FeedCellDelegate : AnyObject {
    func cell(_ cell : FeedCell, wantsToShowCommentsFor post : Post)
    func cell(_ cell : FeedCell, didLike post : Post)
//    func cell(_ cell : FeedCell, didTapProfileFor user : User)
}

class FeedCell : UICollectionViewCell {
    
    var viewModel : PostViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate : FeedCellDelegate?
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "avt")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Tuan Anh"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "hero1")
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var likeBtn : UIButton = {
        let targetSize = CGSize(width: 20, height: 20)
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like")?.scalePreservingAspectRatio(targetSize: targetSize), for: .normal)
        btn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        btn.tintColor = .black
        return btn
    }()
    
    private lazy var commentBtn : UIButton = {
        let targetSize = CGSize(width: 20, height: 20)
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "comment")?.scalePreservingAspectRatio(targetSize: targetSize), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return btn
    }()
    
    private lazy var shareBtn : UIButton = {
        let targetSize = CGSize(width: 20, height: 20)
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "send")?.scalePreservingAspectRatio(targetSize: targetSize), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.text = "Some text caption"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let likesLabel : UILabel = {
        let label = UILabel()
        label.text = "1 like"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let commentLabel : UILabel = {
        let label = UILabel()
        label.text = "View all 2 comments"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: Action
    @objc func handleLike() {
        guard let viewModel = viewModel else { return }
        self.delegate?.cell(self, didLike: viewModel.post)
    }
    
    @objc func handleComment() {
        guard let viewModel = viewModel else { return }
        self.delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configureCollectionViewCell() {
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(nameLabel)
        nameLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(imageView)
        imageView.setDimensions(height: frame.width + 30, width: frame.width)
        imageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        
        let stack = UIStackView(arrangedSubviews: [likeBtn, commentBtn, shareBtn])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: imageView.bottomAnchor, width: 120, height: 50)
        
        addSubview(likesLabel)
        likesLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingRight: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 8)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        captionLabel.text = viewModel.caption
        imageView.sd_setImage(with: viewModel.imageUrl)
        likesLabel.text = viewModel.likeLabelText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        nameLabel.text = viewModel.username
        postTimeLabel.text = viewModel.timestamp
        likeBtn.tintColor = viewModel.likeButtonTintColor
    }
}
