//
//  ProfileController.swift
//  TrackingApp
//
//  Created by tuananhdo on 16/4/24.
//

import UIKit
import SDWebImage
import FirebaseAuth

private let reuseId = "EditCell"
class SettingController : UICollectionViewController {
    
    private var user : User
        
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewController()
    }
    
    func configureCollectionViewController() {
        view.backgroundColor = .white
        navigationItem.title = "Edit Profile"
        navigationController?.title = "Profile"
        collectionView.register(EditCell.self, forCellWithReuseIdentifier: reuseId)
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid : uid) { user in
            self.user = user
        }
    }
 
}

//MARK: - UICollectionViewDataSource
extension SettingController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! EditCell
        cell.viewModel = EditViewModel(user: user)
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SettingController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 80 + 4 + 80
        height += 200
        return CGSize(width: view.frame.width, height: height)
    }
}

extension SettingController : EditCellDelegate {
    func handleUpdateProfile() {
        fetchUser()
        self.collectionView.reloadData()
    }
}
