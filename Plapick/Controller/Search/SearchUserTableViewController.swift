//
//  SearchUserViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/29.
//

import UIKit


protocol SearchUserTableViewControllerProtocol {
    func closeSearchUserTVC()
}


class SearchUserTableViewController: UITableViewController {
    
    // MARK: Property
    var delegate: SearchUserTableViewControllerProtocol?
    var userList: [User] = []
    var currentKeyword: String = ""
    var paramDict: [String: String] = [:]
    var isOpenedChildVC: Bool = false
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
                currentKeyword = "박재"
                paramDict["keyword"] = "박재"
                navigationItem.searchController?.searchBar.text = "박재"
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
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserTVCell.self, forCellReuseIdentifier: "UserTVCell")
        tableView.separatorInset.left = SPACE
        tableView.tableFooterView = UIView(frame: CGRect.zero) // 빈 셀 안보이게
        
        isModalInPresentation = true // 후....
        
        configureView()
        
        setThemeColor()
        
        getUsersRequest.delegate = self
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isOpenedChildVC {
            delegate?.closeSearchUserTVC()
        }
    }
    
    
    // MARK: Function
    func getUsers() {
        getUsersRequest.fetch(vc: self, paramDict: paramDict)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setThemeColor()
    }
    func setThemeColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }
    
    func configureView() {
        
    }
}


// MARK: Extension - TableView
extension SearchUserTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVCell", for: indexPath) as! UserTVCell
        cell.selectionStyle = .none
        cell.user = userList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 + (SPACE_XS * 2)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 + (SPACE_XS * 2)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isOpenedChildVC = true
        let user = userList[indexPath.row]
        let accountVC = AccountViewController(uId: user.id)
        accountVC.delegate = self
        present(UINavigationController(rootViewController: accountVC), animated: true, completion: nil)
    }
}

// MARK: Extension - GetUsers
extension SearchUserTableViewController: GetUsersRequestProtocol {
    func response(userList: [User]?, getUsers status: String) {
        if status == "OK" {
            if let userList = userList {
                self.userList = userList
                tableView.reloadData()
            }
        }
    }
}

// MARK: Extension - SearchBar
extension SearchUserTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2자 이상 (영어는 4자)
        if keyword.utf8.count < 4 {
            return
        }
        
        // 한글 Char 거르기
        let wordList = Array(keyword)
        for word in wordList {
            if KOR_CHAR_LIST.contains(word) {
                return
            }
        }
        
        // 이미 검색한 키워드 (리스트에 뿌려놓음)
        if currentKeyword == keyword { return }
        
        paramDict["keyword"] = keyword
        currentKeyword = keyword
        getUsers()
    }
}

// MARK: Extension - AccountVC
extension SearchUserTableViewController: AccountViewControllerProtocol {
    func closeAccountVC() {
        isOpenedChildVC = false
    }
    
    func follow() {
        getUsers()
    }
}
