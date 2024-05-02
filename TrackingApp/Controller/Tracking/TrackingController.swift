//
//  TrackingController.swift
//  TrackingApp
//
//  Created by tuananhdo on 22/4/24.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "TrackingCell"
private let headerIdentifier = "TrackingHeader"

class TrackingController: UICollectionViewController {
    
    private var tracking = [Tracking]()
    
    private var user : User
    
    init(user : User) {
        self.user = user
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchTracking()
        checkedTracking()
    }
    
    // MARK: - Helpers
    func configureTableView() {
        view.backgroundColor = .white        
        navigationItem.title = "Tracking"
        collectionView.register(TrackingCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TrackingHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    //MARK: - API
    func fetchTracking() {
        TrackingService.fetchTracking(forUser: user) { tracking in
            self.tracking = tracking
            self.collectionView.reloadData()
        }
    }
    
    func checkedTracking() {
        TrackingService.checkIfTodayClickedButton(forUser: user.uid) { result in
            let calender = Calendar.current
            let date = Date()
            let day = calender.component(.day, from: date)
            if self.user.trackingDay == day {
                TrackingService.resetIsCheckedPassed(forUser: self.user) { error in
                    if let error = error {
                        print("DEBUG: Error reset isCheckedPassed \(error.localizedDescription)")
                        return
                    }
                    self.user.isCheckedToday = false
                    self.collectionView.reloadData()
                }
            } else {
                self.user.isCheckedToday = result
            }
            self.collectionView.reloadData()
        }
                
    }
    
}

//MARK: - UICollectionViewDataSource
extension TrackingController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracking.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackingCell
        cell.viewModel = TrackingViewModel(tracking: tracking[indexPath.row])
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TrackingHeader
        header.dayTracking.text = "Day Tracking : \(user.trackingDayCount)"
        header.delegate = self
        header.viewModel = TrackingHeaderViewModel(user: user)
        return header
    }
}

//MAKR: - UICollectionViewDelegateFlowLayout
extension TrackingController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : view.frame.width, height: view.frame.width - 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
    //MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid : uid) { user in
            self.user = user
            self.collectionView.reloadData()
        }
    }
}

//MARK : - TrackingHeaderDelegate
extension TrackingController : TrackingHeaderDelegate {
    
    func didTapTrackingDay(_ header: TrackingHeader) {
        if user.isCheckedToday {
            TrackingService.incrementTrackingDayCount(forUser: user) { error in
                if let error = error {
                    print("DEBUG: Error incrementing tracking day count \(error.localizedDescription)")
                    return
                }
                self.fetchTracking()
                self.fetchUser()
            }
            self.collectionView.reloadData()
        }
    }
    
    func didTapAddTracking() {
        let controller = TrackingUploadController()
        controller.hidesBottomBarWhenPushed = true
        controller.user = self.user
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - TrackingUploadControllerDelegate
extension TrackingController : TrackingUploadControllerDelegate {
    func controllerDidFinishUploading(_ controller: TrackingUploadController) {
        //redired to tracking controller
        controller.navigationController?.popViewController(animated: true)
        fetchTracking()
    }
}




