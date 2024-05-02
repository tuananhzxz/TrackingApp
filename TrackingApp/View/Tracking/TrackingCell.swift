//
//  TrackingCell.swift
//  TrackingApp
//
//  Created by tuananhdo on 23/4/24.
//

import UIKit

class TrackingCell : UICollectionViewCell {
    
    var viewModel : TrackingViewModel? {
        didSet {
            configure()
        }
    }
    
    private let trackingTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let trackingDescription : UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let cardTrackingView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let trackingTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private let typeLabel : UILabel = {
        let label = UILabel()
        label.text = "Type"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .red
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func configureCell() {
        backgroundColor = .white
        
        addSubview(cardTrackingView)
        cardTrackingView.center(inView: self)
        cardTrackingView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        addSubview(trackingTitleLabel)
        trackingTitleLabel.anchor(top: cardTrackingView.topAnchor, left: cardTrackingView.leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(trackingDescription)
        trackingDescription.anchor(top: trackingTitleLabel.bottomAnchor, left: trackingTitleLabel.leftAnchor, paddingTop: 4)
        
        addSubview(trackingTimeLabel)
        trackingTimeLabel.anchor(bottom: cardTrackingView.bottomAnchor, right: cardTrackingView.rightAnchor, paddingBottom: 8, paddingRight: 8)
        
        addSubview(typeLabel)
        typeLabel.anchor(left: cardTrackingView.leftAnchor, bottom: cardTrackingView.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        trackingTitleLabel.text = viewModel.trackingName
        trackingDescription.text = viewModel.trackingDescription
        trackingTimeLabel.text = viewModel.trackingDate
        typeLabel.text = viewModel.trackingType
    }
}
