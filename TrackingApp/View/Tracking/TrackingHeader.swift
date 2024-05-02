//
//  TrackingHeader.swift
//  TrackingApp
//
//  Created by tuananhdo on 23/4/24.
//

import UIKit
import FirebaseAuth

protocol TrackingHeaderDelegate : AnyObject {
    func didTapAddTracking()
    func didTapTrackingDay(_ trackingHeader : TrackingHeader)
}

class TrackingHeader : UICollectionReusableView {
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let timesOfDay = ["7:00", "7:45", "8:30", "9:15", "10:00", "10:45", "11:30"]
    
    weak var delegate : TrackingHeaderDelegate?
    
    var viewModel : TrackingHeaderViewModel? {
        didSet {
            configure()
        }
    }
        
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let cardView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    private let todayWithDayAndMonthLabel : UILabel = {
        let label = UILabel()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        let todayString = formatter.string(from: today)
        label.text = todayString
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var preDayBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handlePreDay), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextDayBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleNextDay), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    private let bottomView = UIView()
    
    private let viewFullWidthEndBottom : UIView = {
        let uv = UIView()
        return uv
    }()
    
    let dayTracking : UILabel = {
        let label = UILabel()
        label.text = "Day Tracking : 10"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var trackingBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tracking", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.setDimensions(height: 30, width: 80)
        button.addTarget(self, action: #selector(handleTracking), for: .touchUpInside)
        return button
    }()
    
    private lazy var addBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemBlue
        button.setDimensions(height: 30, width: 35)
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleUploadTracking), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func handleUploadTracking() {
       delegate?.didTapAddTracking()
    }
    
    @objc func handlePreDay() {
        var selectedIndex = getDateLabelIndexSelected()
        selectedIndex -= 1
        
        if selectedIndex < 11 {
            selectedIndex = 17
        }
        
        changeCircleOrange(selectedIndex: selectedIndex)
        changeTodayWithDayAndMonthLabel(selectedIndex: selectedIndex)
    }

    @objc func handleNextDay() {
        var selectedIndex = getDateLabelIndexSelected()
        selectedIndex += 1
        
        if selectedIndex > 17 {
            selectedIndex = 11
        }
        
        changeCircleOrange(selectedIndex: selectedIndex)
        changeTodayWithDayAndMonthLabel(selectedIndex: selectedIndex)
    }
    
    @objc func dateLabelTapped(sender: UITapGestureRecognizer) {
        guard let selectedLabel = sender.view as? UILabel else { return }
        
        guard let selectedIndex = subviews.firstIndex(of: selectedLabel) else { return }
        
        changeCircleOrange(selectedIndex: selectedIndex)
        changeTodayWithDayAndMonthLabel(selectedIndex: selectedIndex)
    }
    
    @objc func handleTracking() {
        delegate?.didTapTrackingDay(self)
        trackingBtn.backgroundColor = .systemGray
        trackingBtn.setTitleColor(.black, for: .normal)
        trackingBtn.isEnabled = false
    }
    
    //MARK: - Helper
    func configure() {
        guard let viewModel = viewModel else { return }
        
        trackingBtn.setTitle(viewModel.trackingButtonText, for: .normal)
        trackingBtn.backgroundColor = viewModel.trackingButtonColor
        trackingBtn.setTitleColor(viewModel.trackingButtonTextColor, for: .normal)
        trackingBtn.isEnabled = viewModel.trackingIsEnabled
    }
    
    func configureHeader() {
        backgroundColor = .white
        
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        addSubview(cardView)
        cardView.setDimensions(height: 40, width: (frame.width / 2) - 20)
        cardView.centerY(inView: label, leftAnchor: label.rightAnchor, paddingLeft: 20)
        
        addSubview(todayWithDayAndMonthLabel)
        todayWithDayAndMonthLabel.centerY(inView: cardView, leftAnchor: cardView.leftAnchor, paddingLeft: 15)
        
        let stack = UIStackView(arrangedSubviews: [preDayBtn, nextDayBtn])
        stack.axis = .horizontal
        stack.spacing = 20
        
        addSubview(stack)
        stack.centerY(inView: cardView, rightAnchor: rightAnchor, paddingRight: 20)
        
        for (index, day) in daysOfWeek.enumerated() {
            let dayLabel = UILabel(frame: CGRect(x: CGFloat(index) * (frame.width / 7), y: 70, width: frame.width / 7, height: 30))
            dayLabel.text = day
            dayLabel.textAlignment = .center
            dayLabel.font = UIFont.systemFont(ofSize: 14)
            dayLabel.textColor = .lightGray
            addSubview(dayLabel)
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentWeekday = calendar.component(.weekday, from: currentDate)
        let daysOffset = currentWeekday - 2
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i - daysOffset, to: currentDate)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d"
            let dateString = dateFormatter.string(from: date)
            let dateLabel = UILabel(frame: CGRect(x: CGFloat(i) * (frame.width / 7), y: 100, width: frame.width / 7, height: 30))
            dateLabel.text = dateString
            dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
            dateLabel.textAlignment = .center
            dateLabel.isUserInteractionEnabled = true
            dateLabel.layer.cornerRadius = dateLabel.frame.height / 2
            dateLabel.layer.masksToBounds = true
            if i == currentWeekday - 2 {
                dateLabel.textColor = .white
                dateLabel.backgroundColor = .orange
                dateLabel.frame = CGRect(x: CGFloat(i) * (frame.width / 7) + 16, y: 100, width: 30, height: 30)
            } else {
                dateLabel.textColor = .black
                dateLabel.backgroundColor = .clear
            }
            dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped(sender:))))
            addSubview(dateLabel)
        }
        
        for (index, time) in timesOfDay.enumerated() {
            let timeLabel = UILabel(frame: CGRect(x: CGFloat(index) * (frame.width / 7), y: 130, width: frame.width / 7, height: 30))
            timeLabel.text = time
            timeLabel.font = UIFont.systemFont(ofSize: 14)
            timeLabel.textAlignment = .center
            addSubview(timeLabel)
            bottomView.backgroundColor = .lightGray
            addSubview(bottomView)
            bottomView.anchor(top: timeLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, height: 0.75)
            addSubview(viewFullWidthEndBottom)
            viewFullWidthEndBottom.anchor(top: bottomView.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 1, height: 80)
        }
        
        let stack1 = UIStackView(arrangedSubviews: [dayTracking, addBtn ,trackingBtn])
        stack1.axis = .horizontal
        stack1.spacing = 20
        
        addSubview(stack1)
        stack1.center(inView: viewFullWidthEndBottom)
        stack1.setHeight(40)
        stack1.anchor(top: bottomView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
    }
    
}

extension TrackingHeader {
    private func changeTodayWithDayAndMonthLabel(selectedIndex: Int) {
        let currentDate = Date()
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: selectedIndex - 15, to: currentDate)!
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        let dateString = formatter.string(from: newDate)
        todayWithDayAndMonthLabel.text = dateString
    }
    
    private func changeCircleOrange(selectedIndex: Int) {
        showLoaderr(true)
        for (index, subview) in subviews.enumerated() {
            showLoaderr(false)
            if let dateLabel = subview as? UILabel {
                if index == selectedIndex {
                    dateLabel.textColor = .white
                    dateLabel.backgroundColor = .orange
                    dateLabel.frame = CGRect(x: CGFloat(index - 11) * (frame.width / 7) + 16, y: 100, width: 30, height: 30)
                } else {
                    dateLabel.textColor = .black
                    dateLabel.backgroundColor = .clear
                }
            }
        }
    }
    
    private func getDateLabelIndexSelected() -> Int {
        for (index, subview) in subviews.enumerated() {
            if let dateLabel = subview as? UILabel {
                if dateLabel.backgroundColor == .orange {
                    return index
                }
            }
        }
        return 0
    }
}
