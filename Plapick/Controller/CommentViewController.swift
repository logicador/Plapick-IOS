//
//  CommentViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/04/01.
//

import UIKit


class CommentViewController: UIViewController {
    
    // MARK: Property
    var userCommentList: [UserComment] = []
    let getUserCommentsRequest = GetUserCommentsRequest()
    let removePostsCommentRequest = RemovePostsCommentRequest()
    let removePostsReCommentRequest = RemovePostsReCommentRequest()
    let removePlaceCommentRequest = RemovePlaceCommentRequest()
    let getPostsRequest = GetPostsRequest()
    
    
    // MARK: View
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UserCommentTVCell.self, forCellReuseIdentifier: "UserCommentTVCell")
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
        
        navigationItem.title = "작성한 댓글"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        getUserCommentsRequest.delegate = self
        removePostsCommentRequest.delegate = self
        removePostsReCommentRequest.delegate = self
        removePlaceCommentRequest.delegate = self
        getPostsRequest.delegate = self
        
        getUserCommentsRequest.fetch(vc: self, paramDict: [:])
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
    
    // MARK: Function - @OBJC
    @objc func refreshed() {
        getUserCommentsRequest.fetch(vc: self, paramDict: [:])
    }
}


// MARK: TableView
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCommentTVCell", for: indexPath) as! UserCommentTVCell
        cell.selectionStyle = .none
        cell.userComment = userCommentList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "정말 댓글을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            let userComment = self.userCommentList[indexPath.row]
            if userComment.targetType == "POC" {
                self.removePostsCommentRequest.fetch(vc: self, paramDict: ["pocId": String(userComment.id)])
            } else if userComment.targetType == "PORC" {
                self.removePostsReCommentRequest.fetch(vc: self, paramDict: ["porcId": String(userComment.id)])
            } else if userComment.targetType == "PC" {
                self.removePlaceCommentRequest.fetch(vc: self, paramDict: ["pcId": String(userComment.id)])
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userComment = userCommentList[indexPath.row]
        
        let alert = UIAlertController(title: nil, message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        
        if userComment.targetType == "POC" || userComment.targetType == "PORC" {
            alert.addAction(UIAlertAction(title: "게시물 보러가기", style: .default, handler: { (_) in
                self.getPostsRequest.fetch(vc: self, paramDict: ["mode": "SINGLE", "poId": String(userComment.targetId)])
            }))
        } else if userComment.targetType == "PC" {
            alert.addAction(UIAlertAction(title: "플레이스 보러가기", style: .default, handler: { (_) in
                let placeVC = PlaceViewController()
                placeVC.pId = userComment.targetId
                self.navigationController?.pushViewController(placeVC, animated: true)
            }))
        }
        alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { (_) in
            let alert = UIAlertController(title: nil, message: "정말 댓글을 삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                if userComment.targetType == "POC" {
                    self.removePostsCommentRequest.fetch(vc: self, paramDict: ["pocId": String(userComment.id)])
                } else if userComment.targetType == "PORC" {
                    self.removePostsReCommentRequest.fetch(vc: self, paramDict: ["porcId": String(userComment.id)])
                } else if userComment.targetType == "PC" {
                    self.removePlaceCommentRequest.fetch(vc: self, paramDict: ["pcId": String(userComment.id)])
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
}

// MARK: HTTP - GetUserComments
extension CommentViewController: GetUserCommentsRequestProtocol {
    func response(userCommentList: [UserComment]?, getUserComments status: String) {
        print("[HTTP RES]", getUserCommentsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let userCommentList = userCommentList else { return }
            
            self.userCommentList = userCommentList
            tableView.reloadData()
        }
        
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: HTTP - RemovePostsComment
extension CommentViewController: RemovePostsCommentRequestProtocol {
    func response(pocId: Int?, removePostsComment status: String) {
        print("[HTTP RES]", removePostsCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pocId = pocId else { return }
            
            for (i, userComment) in userCommentList.enumerated() {
                if userComment.targetType == "POC" && userComment.id == pocId {
                    userCommentList.remove(at: i)
                    break
                }
            }
            tableView.reloadData()
        }
    }
}

// MARK: HTTP - RemovePostsReComment
extension CommentViewController: RemovePostsReCommentRequestProtocol {
    func response(porcId: Int?, removePostsReComment status: String) {
        print("[HTTP RES]", removePostsReCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let porcId = porcId else { return }
            
            for (i, userComment) in userCommentList.enumerated() {
                if userComment.targetType == "PORC" && userComment.id == porcId {
                    userCommentList.remove(at: i)
                    break
                }
            }
            tableView.reloadData()
        }
    }
}

// MARK: HTTP - RemovePlaceComment
extension CommentViewController: RemovePlaceCommentRequestProtocol {
    func response(pcId: Int?, removePlaceComment status: String) {
        print("[HTTP RES]", removePlaceCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pcId = pcId else { return }
            
            for (i, userComment) in userCommentList.enumerated() {
                if userComment.targetType == "PC" && userComment.id == pcId {
                    userCommentList.remove(at: i)
                    break
                }
            }
            tableView.reloadData()
        }
    }
}

// MARK: HTTP - GetPosts
extension CommentViewController: GetPostsRequestProtocol {
    func response(postsList: [Posts]?, mode: String?, getPosts status: String) {
        print("[HTTP RES]", getPostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsList = postsList else { return }
            
            if postsList.count > 0 {
                let postsVC = PostsViewController()
                postsVC.postsList = postsList
                postsVC.isEnd = true
                navigationController?.pushViewController(postsVC, animated: true)
                
            } else {
                let alert = UIAlertController(title: nil, message: "이미 삭제되었거나 없는 게시물입니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
