//
//  CommentController.swift
//  TrackingApp
//
//  Created by tuananhdo on 20/4/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class CommentController : UICollectionViewController {
    
    private var comment = [Comment]()
    
    private let post : Post
        
    init(post : Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private lazy var commentActionView : CommentAcessoryTextView = {
       let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentAcessoryTextView(frame: frame)
        cv.delegateNew = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchComment()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentActionView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    //MAKR: API
    func fetchComment() {
        CommentService.fetchComments(postId: post.postId) { comment in
            self.comment = comment
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comment.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comment[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommentController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = CommentViewModel(comment: comment[indexPath.row])
        let height = viewModel.size(forWidth: self.view.frame.width).height + 40
        return CGSize(width: view.frame.width, height: height)
    }
}

// MARK: - CommentAcessoryTextViewDelegate
extension CommentController : CommentAcessoryTextViewDelegate {
    func inputTextView(_ inputTextView: CommentAcessoryTextView, wantsToUploadComment comment: String) {
        guard let tab = tabBarController as? MainTabBarController else { return }
        guard let user = tab.user else { return }
        
        showLoader(true)
        CommentService.uploadComment(comment: comment, postId: post.postId, user: user) { (error) in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to upload comment with error \(error.localizedDescription)")
                return
            }
            inputTextView.clearCommentTextView()
            NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: user, type: NotificationType.comment, post: self.post)
        }
        self.collectionView.reloadData()
    }
}

extension CommentController : CommentCellDelegate {
    func cell(_ cell: CommentCell, wantsToShowProfileFor uid: String) {
        let uid = post.ownerUid
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
   
}

