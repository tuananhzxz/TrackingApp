//
//  SearchController.swift
//  TrackingApp
//
//  Created by tuananhdo on 16/4/24.
//

import UIKit
private let resueId = "UserCell"

class SearchController : UITableViewController {
    
    private var users = [User]()
    private var filteredUsers = [User]()
    
    private var isFiltering : Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    //MARK: - Helper
    func configureUI() {
        tableView.backgroundColor = .systemBackground
        tableView.register(UserCell.self, forCellReuseIdentifier: resueId)
        tableView.rowHeight = 64
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    //MARK: - API
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
        }
        self.tableView.reloadData()
    }
}

//MARK : - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueId, for: indexPath) as! UserCell
        let users = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserViewModel(user: users)
        return cell
    }
}

//MARK : - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProfileController(user : users[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UISearchResultsUpdating
extension SearchController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ $0.username.contains(searchText) || $0.fullname.contains(searchText) || $0.email.contains(searchText) || $0.school.contains(searchText)})
        
        self.tableView.reloadData()
    }
}
