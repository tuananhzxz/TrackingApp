//
//  ProfileController.swift
//  TrackingApp
//
//  Created by tuananhdo on 16/4/24.
//

import UIKit
import SDWebImage
import FirebaseAuth

private let reuseId = "ProfileCell"
class ProfileController : UICollectionViewController {
    
    private var user : User {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        checkIfUserLoggedIn()
        fetchUser()
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid : uid) { user in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    func configureCollectionViewController() {
        view.backgroundColor = .white
        navigationItem.title = user.username
        navigationController?.title = "Profile"
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: reuseId)
    }
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! ProfileCell
        cell.viewModel = UserViewModel(user: user)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 80 + 4 + 80
        height += 200
        return CGSize(width: view.frame.width, height: height)
    }
}
