//
//  CommentCell.swift
//  TrackingApp
//
//  Created by tuananhdo on 20/4/24.
//

import UIKit
import SDWebImage

protocol CommentCellDelegate: AnyObject {
    func cell(_ cell: CommentCell, wantsToShowProfileFor uid : String)
}

class CommentCell : UICollectionViewCell {
    
    var viewModel : CommentViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: CommentCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        iv.addGestureRecognizer(gesture)
        return iv
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let timeCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "2m"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureUI() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(timeCommentLabel)
        timeCommentLabel.anchor(top: commentLabel.bottomAnchor, left: commentLabel.leftAnchor, paddingTop: 4)
    }
    
    //MARK: - Actions
    func configure() {
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = viewModel.username
        timeCommentLabel.text = viewModel.timestamp
    }
    
    @objc func showProfile() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowProfileFor: viewModel.comment.uid)
    }
}
