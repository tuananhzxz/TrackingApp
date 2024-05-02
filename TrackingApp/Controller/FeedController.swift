//
//  FeedController.swift
//  TrackingApp
//
//  Created by tuananhdo on 16/4/24.
//

import UIKit
import FirebaseAuth
private let reuseId = "FeedCell"

class FeedController: UICollectionViewController {
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewController()
        checkIfUserLoggedIn()
        fetchPosts()
    }
    
    // MARK: - Helpers
    func configureCollectionViewController() {
        view.backgroundColor = .white
        navigationItem.title = "Feed"
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseId)
                
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    //MARK: - Action
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginViewController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - API
    func fetchPosts() {
        
        PostService.fetchPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPost()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserLikedPost() {
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { didLike in
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! FeedCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension FeedController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 80 + 4 + 80
        height += 50
        return CGSize(width: view.frame.width, height: height)
    }
}

extension FeedController : FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = tabBarController as? MainTabBarController else { return }
        guard let user = tab.user else { return }
        cell.viewModel?.post.didLike.toggle()
        if post.didLike {
            PostService.unlikePost(post: post) { _ in
                cell.viewModel?.post.likes -= 1
                cell.viewModel?.post.didLike = false
            }
        } else {
            PostService.likePost(post: post) { _ in
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: NotificationType.like, post: post)
                cell.viewModel?.post.likes += 1
                cell.viewModel?.post.didLike = true
            }
        }
    }
}

//MARK: LoginControllerDelegate
extension FeedController : AuthenticationDelegate {
    func authenticationDidComplete(_ controller: LoginViewController) {
        controller.dismiss(animated: true, completion: nil)
        fetchPosts()
    }
    
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        fetchPosts()
    }
}
