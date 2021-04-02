//
//  PostsViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/25.
//

import UIKit


protocol PostsViewControllerProtocol {
    func removePosts(poId: Int)
    func likePosts(poId: Int, isLike: String)
    func editPosts(posts: Posts)
}


class PostsViewController: UIViewController {
    
    // MARK: Property
    var delegate: PostsViewControllerProtocol?
    let app = App()
    var poId: Int?
    var postsList: [Posts] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let getPostsRequest = GetPostsRequest()
    var mode = "USER"
    var uId: Int?
    var pId: Int?
    var page = 1
    var isLoading = false
    var isEnd = false
    let removePostsRequest = RemovePostsRequest()
    let likePostsRequest = LikePostsRequest()
    
    
    // MARK: View
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(PostsTVCell.self, forCellReuseIdentifier: "PostsTVCell")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: .zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.alwaysBounceVertical = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "게시물"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        getPostsRequest.delegate = self
        removePostsRequest.delegate = self
        likePostsRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func getPosts() {
        isLoading = true
        
        var paramDict: [String: String] = [:]
        paramDict["mode"] = mode
        paramDict["page"] = String(page)
        paramDict["limit"] = String(GET_POSTS_LIMIT)
        
        if mode == "ALL" {
            
        } else if mode == "USER" {
            guard let uId = self.uId else { return }
            paramDict["uId"] = String(uId)
        } else if mode == "PLACE" {
            guard let pId = self.pId else { return }
            paramDict["pId"] = String(pId)
        }
        
        getPostsRequest.fetch(vc: self, paramDict: paramDict)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = tableView.frame.height

        if offsetY > contentHeight - frameHeight {
            if !isLoading && !isEnd {
                page += 1
                getPosts()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let poId = self.poId else { return }
        
        if postsList.count == 1 {
            self.poId = nil
            return
        }
        
        for (i, posts) in postsList.enumerated() {
            if posts.po_id == poId {
                tableView.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .top)
                self.poId = nil
                break
            }
        }
    }
}


// MARK: EditPostsVC
extension PostsViewController: EditPostsViewControllerProtocol {
    func editPosts(posts: Posts) {
        delegate?.editPosts(posts: posts)
        
        for (i, _posts) in postsList.enumerated() {
            if _posts.po_id == posts.po_id {
                postsList[i] = posts
                break
            }
        }
        tableView.reloadData()
    }
}

// MARK: TableView
extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTVCell", for: indexPath) as! PostsTVCell
        cell.selectionStyle = .none
        cell.posts = postsList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.5
    }
}

// MARK: PostsTVCell
extension PostsViewController: PostsTVCellProtocol {
    func more(posts: Posts) {
        let alert = UIAlertController(title: nil, message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "공유하기", style: .default, handler: { (_) in
            var objectsToShare = [String]()
            objectsToShare.append("공유하기테스트")
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            // 공유하기 기능 중 제외할 기능이 있을 때 사용
    //        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }))
        if posts.po_u_id == app.getUserId() {
            alert.addAction(UIAlertAction(title: "수정하기", style: .default, handler: { (_) in
                let editPostsVC = EditPostsViewController()
                editPostsVC.posts = posts
                editPostsVC.delegate = self
                let editPostsNavVC = UINavigationController(rootViewController: editPostsVC)
                editPostsNavVC.modalPresentationStyle = .fullScreen
                self.present(editPostsNavVC, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { (_) in
                let alert = UIAlertController(title: nil, message: "정말 게시물을 삭제하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                    self.removePostsRequest.fetch(vc: self, paramDict: ["poId": String(posts.po_id)])
                }))
                self.present(alert, animated: true, completion: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: { (_) in
                let reportVC = ReportViewController()
                reportVC.targetType = "POSTS"
                reportVC.targetId = posts.po_id
                self.present(UINavigationController(rootViewController: reportVC), animated: true, completion: nil)
            }))
        }
        present(alert, animated: true)
    }
    
    func selectUser(uId: Int) {
        if app.getUserId() == uId { return }
        
        let userVC = UserViewController()
        userVC.uId = uId
        navigationController?.pushViewController(userVC, animated: true)
    }
      
    func selectPlace(pId: Int, pName: String) {
        let placeVC = PlaceViewController()
        placeVC.navigationItem.title = pName
        placeVC.pId = pId
        navigationController?.pushViewController(placeVC, animated: true)
    }
    
    func likePosts(posts: Posts) {
        likePostsRequest.fetch(vc: self, paramDict: ["poId": String(posts.po_id)])
    }
    
    func commentPosts(posts: Posts) {
        let postsCommentVC = PostsCommentViewController()
        postsCommentVC.posts = posts
        present(UINavigationController(rootViewController: postsCommentVC), animated: true, completion: nil)
    }
}

// MARK: HTTP - GetPosts
extension PostsViewController: GetPostsRequestProtocol {
    func response(postsList: [Posts]?, mode: String?, getPosts status: String) {
        print("[HTTP RES]", getPostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsList = postsList else { return }
            
            self.postsList.append(contentsOf: postsList)
            tableView.reloadData()
            
            if postsList.count < GET_POSTS_LIMIT { isEnd = true }
        }
        
        isLoading = false
    }
}

// MARK: HTTP - RemovePosts
extension PostsViewController: RemovePostsRequestProtocol {
    func response(poId: Int?, removePosts status: String) {
        print("[HTTP RES]", removePostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let poId = poId else { return }
            
            delegate?.removePosts(poId: poId)
            
            for (i, posts) in postsList.enumerated() {
                if posts.po_id == poId {
                    postsList.remove(at: i)
                    break
                }
            }
            tableView.reloadData()
        }
    }
}

// MARK: HTTP - LikePosts
extension PostsViewController: LikePostsRequestProtocol {
    func response(poId: Int?, isLike: String?, likePosts status: String) {
        print("[HTTP RES]", likePostsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let poId = poId else { return }
            guard let isLike = isLike else { return }
            
            delegate?.likePosts(poId: poId, isLike: isLike)
        }
    }
}
