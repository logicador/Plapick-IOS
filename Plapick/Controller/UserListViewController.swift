//
//  UserListViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/02.
//

import UIKit


class UserListViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var mode = "FOLLOWER" // FOLLOWING / BLOCK
    var uId: Int? {
        didSet {
            if mode == "FOLLOWER" {
                navigationItem.title = "팔로워"
            } else if mode == "FOLLOWING" {
                navigationItem.title = "팔로잉"
            }
            
            getUsers()
        }
    }
    let getUsersRequest = GetUsersRequest()
    var userList: [User] = []
    var page = 1
    var isLoading = false
    var isEnd = false
    
    
    // MARK: View
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UserTVCell.self, forCellReuseIdentifier: "UserTVCell")
        tv.separatorInset.left = 0
        tv.tableFooterView = UIView(frame: .zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.alwaysBounceVertical = true
        tv.refreshControl = UIRefreshControl()
        tv.refreshControl?.addTarget(self, action: #selector(refreshed), for: .valueChanged)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        getUsersRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        
        tableView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func getUsers() {
        guard let uId = self.uId else { return }
        
        isLoading = true
        
        getUsersRequest.fetch(vc: self, paramDict: ["mode": mode, "uId": String(uId), "page": String(page)])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = tableView.frame.height

        if offsetY > contentHeight - frameHeight {
            if !isLoading && !isEnd {
                page += 1
                getUsers()
            }
        }
    }
    
    // MARK: Function - @OBJC
    @objc func refreshed() {
        page = 1
        isEnd = false
        getUsers()
    }
}


// MARK: TableView
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVCell", for: indexPath) as! UserTVCell
        cell.selectionStyle = .none
        cell.user = userList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SPACE_XS + 50 + SPACE_XS
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row]
        
        if user.u_id == app.getUserId() { return }
        
        let userVC = UserViewController()
        userVC.uId = user.u_id
        userVC.delegate = self
        navigationController?.pushViewController(userVC, animated: true)
    }
}

// MARK: UserVC
extension UserListViewController: UserViewControllerProtocol {
    func follow(uId: Int) {
        page = 1
        isEnd = false
        getUsers()
    }
}

// MARK: HTTP - GetUsers
extension UserListViewController: GetUsersRequestProtocol {
    func response(userList: [User]?, getUsers status: String) {
        print("[HTTP RES]", getUsersRequest.apiUrl, status)
        
        if status == "OK" {
            guard let userList = userList else { return }
            
            self.userList = userList
            tableView.reloadData()
            
            if userList.count < GET_USERS_LIMIT { isEnd = true }
        }
        isLoading = false
        tableView.refreshControl?.endRefreshing()
    }
}
