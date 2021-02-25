//
//  SearchUserViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit


class SearchUserViewController: UIViewController {
    
    // MARK: Property
    var userList: [User] = []
    var currentKeyword: String = ""
    var paramDict: [String: String] = [:]
    var user: User? {
        didSet {
            guard let user = self.user else { return }
            paramDict["uId"] = String(user.id)
        }
    }
    var mode: String? {
        didSet {
            paramDict["mode"] = mode
            
            if mode == "KEYWORD" {
                navigationItem.title = "사람 검색"
                
                let searchController = UISearchController(searchResultsController: nil)
                searchController.automaticallyShowsCancelButton = false
                searchController.hidesNavigationBarDuringPresentation = false
                searchController.obscuresBackgroundDuringPresentation = false
                searchController.searchBar.placeholder = "닉네임을 입력해주세요."
                searchController.searchBar.delegate = self

                navigationItem.searchController = searchController
                navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
                
                // MARK: For DEV_DEBUG
                currentKeyword = "서원"
                paramDict["keyword"] = "서원"
                navigationItem.searchController?.searchBar.text = "서원"
                getUsers()
                
            } else if mode == "FOLLOWER" {
                navigationItem.title = "팔로워"
                getUsers()
                
            } else if mode == "FOLLOWING" {
                navigationItem.title = "팔로잉"
                getUsers()
            }
        }
    }
    let getUsersRequest = GetUsersRequest()
    
    
    // MARK: View
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UserTVCell.self, forCellReuseIdentifier: "UserTVCell")
        tv.separatorInset.left = SPACE
        tv.tableFooterView = UIView(frame: .zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getUsersRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func getUsers() {
        getUsersRequest.fetch(vc: self, paramDict: paramDict)
    }
}


// MARK: TableView
extension SearchUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userList.count > 0 { tableView.backgroundView = nil }
        else {
            let bgView = UIView()
            
            let label = UILabel()
            label.text = "사용자가 없습니다."
            label.font = .systemFont(ofSize: 14)
            label.textColor = .systemGray
            label.translatesAutoresizingMaskIntoConstraints = false
            
            bgView.addSubview(label)
            label.topAnchor.constraint(equalTo: bgView.topAnchor, constant: SPACE_XXL).isActive = true
            label.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
            
            tableView.backgroundView = bgView
        }
        
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVCell", for: indexPath) as! UserTVCell
        cell.selectionStyle = .none
        cell.user = userList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 + (SPACE_XS * 2)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 + (SPACE_XS * 2)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
        
        let user = userList[indexPath.row]
        let accountVC = AccountViewController()
        accountVC.user = user
        accountVC.delegate = self
        navigationController?.pushViewController(accountVC, animated: true)
    }
}

// MARK: SearchBar
extension SearchUserViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if keyword.count < 2 { return }
        
        // 한글 Char 거르기
        let wordList = Array(keyword)
        for word in wordList {
            if KOR_CHAR_LIST.contains(word) { return }
        }
        
        // 이미 검색한 키워드 (리스트에 뿌려놓음)
        if currentKeyword == keyword { return }
        
        paramDict["keyword"] = keyword
        currentKeyword = keyword
        getUsers()
    }
}

// MARK: HTTP - GetUsers
extension SearchUserViewController: GetUsersRequestProtocol {
    func response(userList: [User]?, getUsers status: String) {
        print("[HTTP RES]", getUsersRequest.apiUrl, status)
        
        if status == "OK" {
            guard let userList = userList else { return }
            
            self.userList = userList
            tableView.reloadData()
        }
    }
}

// MARK: AccountVC
extension SearchUserViewController: AccountViewControllerProtocol {
    func follow() {
        getUsers()
    }
}
