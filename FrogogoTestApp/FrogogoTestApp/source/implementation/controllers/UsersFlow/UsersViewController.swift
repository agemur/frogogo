//
//  UsersViewController.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

extension UsersViewController: UsersChangedDelegate {
    func usersDidUpdate(user: UserModel) {
        userRepository.addItem(item: user)
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
    }
}

class UsersViewController: BaseViewController {
    @IBOutlet weak var usersTableView: UITableView!
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var userRepository = UserRepository()
    private lazy var requestQueue = RequestQueueService<IndexPath>()
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Users"
        
        usersTableView.setupTableView(
            delegate: self,
            dataSource: self,
            cellsIdentifiers: [UserTableViewCell.reuseIdentifier])
        usersTableView.refreshControl = refreshControl
        refreshControl.tintColor = .orange
        refreshControl.addTarget(self, action: #selector(getUsers), for: .valueChanged)
        
        let addUser = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(openDetailForCreate))
        self.navigationItem.rightBarButtonItem = addUser
        
        getUsers()
    }
    
    //MARK: - Custom methods
    @objc func openDetailForCreate () {
        goToDetail()
    }
    
    func goToDetail(
        screenType: UserDetailViewController.ScreenType = .create,
        user: UserModel? = nil
    ) {
        let storyboard = UIStoryboard(name: "UserFlowStoryboard", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "UserDetailViewController") as! UserDetailViewController
        vc.screenType = screenType
        vc.userModel = user
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - SERVER API
    @objc func getUsers() {
        APIClient.getUsers {[weak self] (model, error) in
            DispatchQueue.main.async {
                self?.updateData(users: model, error: error)
            }
        }
    }
    
    private func updateData(users: [UserModel]?, error: Error?) {
        self.refreshControl.endRefreshing()
        if let error = error {
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            let okAction = UIAlertAction(title: "Retry", style: .default) { (action) in
                self.getUsers()
            }
            self.showAlert(
                title: error.localizedDescription,
                message: nil,
                actions: [cancelAction, okAction],
                style: .alert)
        }
        
        guard let users = users else { return }
        userRepository.clear()
        _ = users.map({self.userRepository.addItem(item: $0)})
        self.usersTableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.dataStateDidChanged(self.userRepository.getState())
        return self.userRepository.countItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = self.userRepository.getItem(by: indexPath.row) else {
            return UITableViewCell()
        }
        let cell: UserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.nameLabel.text = "\(user.firstName) \(user.lastName)"
        cell.emailLabel.text = user.email
        
        if let url = user.avatarURL {
            cell.avatarImageView.image = nil
            cell.activityLoad.isHidden = false
            cell.activityLoad.startAnimating()
            
            let request = cell.avatarImageView.download(
                from: url,
                contentMode: .scaleAspectFill
            ) { [weak self] (isSuccess) in
                self?.requestQueue.cancelRequest(by: indexPath)
                cell.activityLoad.stopAnimating()
                guard !isSuccess else { return }
                cell.avatarImageView.image = UIImage(named: "placeholder")
            }
            requestQueue.addRequest(request, for: indexPath)
        } else {
            cell.activityLoad.stopAnimating()
            cell.avatarImageView.image = UIImage(named: "placeholder")
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let user = userRepository.getItem(by: indexPath.row) else {
            return
        }
        goToDetail(screenType: .show, user: user)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
