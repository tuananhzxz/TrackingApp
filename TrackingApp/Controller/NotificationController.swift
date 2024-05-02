//
//  NotificationController.swift
//  TrackingApp
//
//  Created by tuananhdo on 16/4/24.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController : UITableViewController {
    
    private var notification = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchNotifications()
    }
    
    // MARK: - Helpers
    func configureUI() {
        tableView.backgroundColor = .white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    //MARK: - API
    func fetchNotifications() {
        NotificationService.fetchNotification { notifications in
            self.notification = notifications
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notification[indexPath.row])
        return cell
    }
}

