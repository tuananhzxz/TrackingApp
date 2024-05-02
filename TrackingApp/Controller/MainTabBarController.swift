//
//  MainTabBarController.swift
//  TrackingApp
//
//  Created by tuananhdo on 16/4/24.
//

import UIKit
import FirebaseAuth
import YPImagePicker

class MainTabBarController : UITabBarController {
    
    var user : User? {
        didSet {
            guard let user = user else { return }
            configure(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLogin()
        fetchApi()
    }
    
    func fetchApi() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func checkIfUserLogin() {
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
    
    func configure(withUser user: User) {
        
        view.backgroundColor = .white
        self.delegate = self
        
        let home = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(unseletedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: home)
        
        let tracking = TrackingController(user : user)
        let nav2 = templateNavigationController(unseletedImage: UIImage(systemName: "square.and.pencil.circle")!, selectedImage: UIImage(systemName: "square.and.pencil.circle.fill")!, rootViewController: tracking)
        
        let post = PostController()
        let nav3 = templateNavigationController(unseletedImage: UIImage(named: "upload_unselected")!, selectedImage: UIImage(named: "upload_selected")!, rootViewController: post)
        
        let notifications = NotificationController()
        let nav4 = templateNavigationController(unseletedImage: UIImage(named: "bell_unselected")!, selectedImage: UIImage(named: "bell_selected")!, rootViewController: notifications)
        
        let search = SearchController()
        let nav5 = templateNavigationController(unseletedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: search)
        nav5.tabBarItem.title = "Search user"
        
        let profile = ProfileController(user: user)
        let nav6 = templateNavigationController(unseletedImage: UIImage(named: "user")!, selectedImage: UIImage(named: "userSelected")!, rootViewController: profile)
        nav6.tabBarItem.title = "Profile"
        
        let settings = SettingController(user: user)
        let nav7 = templateNavigationController(unseletedImage: UIImage(systemName: "gearshape")!, selectedImage: UIImage(systemName: "gearshape.fill")!, rootViewController: settings)
        nav7.tabBarItem.title = "Edit Profile"
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5, nav6, nav7]
        customizeMoreTab()
    }
    
    func customizeMoreTab() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
       
        if let topViewController = self.moreNavigationController.topViewController {
            topViewController.navigationItem.title = "More"
            topViewController.navigationItem.rightBarButtonItem = logoutButton
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginViewController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    func templateNavigationController(unseletedImage : UIImage ,selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let targetSize = CGSize(width: 30, height: 30)
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.selectedImage = selectedImage.scalePreservingAspectRatio(targetSize: targetSize)
        nav.tabBarItem.image = unseletedImage.scalePreservingAspectRatio(targetSize: targetSize)
        nav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func didFinishimagePicker(picker: YPImagePicker) {
        guard let user = user else { return }
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                let controller = UploadPostController(user: user)
                controller.selectedImage = selectedImage
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - UITabarControllerDelegate
extension MainTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishimagePicker(picker: picker)
        }
        return true
    }
}

//MARK:
extension MainTabBarController : UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        let feednav = viewControllers?.first as! UINavigationController
        let feed = feednav.viewControllers.first as! FeedController
        feed.handleRefresh()
    }
}

//MARK: - LoginControllerDelegate
extension MainTabBarController : AuthenticationDelegate {
    func authenticationDidComplete(_ controller: LoginViewController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
    }
    
    func authenticationComplete() {
        dismiss(animated: true)
        fetchApi()
    }
}
