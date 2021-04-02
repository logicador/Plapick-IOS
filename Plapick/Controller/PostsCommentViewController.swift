//
//  PostsCommentViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import UIKit


class PostsCommentViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var posts: Posts? {
        didSet {
            guard let posts = self.posts else { return }
            
            getPostsCommentsRequest.fetch(vc: self, paramDict: ["poId": String(posts.po_id)])
        }
    }
    var postsCommentList: [PostsComment] = []
    let getPostsCommentsRequest = GetPostsCommentsRequest()
    let addPostsCommentRequest = AddPostsCommentRequest()
    let removePostsCommentRequest = RemovePostsCommentRequest()
    var bottomContainerBottomCons: NSLayoutConstraint?
    var commentTextTrailingCons: NSLayoutConstraint?
    
    
    // MARK: View
    lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var commentTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = LINE_WIDTH
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var commentTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.placeholder = "이곳에 댓글을 입력합니다. (100자 까지)"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.alpha = 0
        button.setTitle("게시", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var bottomButtonTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(PostsCommentTVCell.self, forCellReuseIdentifier: "PostsCommentTVCell")
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
        
        view.backgroundColor = .systemGray6
        
        navigationItem.title = "댓글"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        getPostsCommentsRequest.delegate = self
        addPostsCommentRequest.delegate = self
        removePostsCommentRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        commentTextContainerView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        commentTextContainerView.layer.borderColor = UIColor.separator.cgColor
        tableView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(bottomContainerView)
        bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomContainerBottomCons = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomContainerBottomCons?.isActive = true
        
        bottomContainerView.addSubview(commentTextContainerView)
        commentTextContainerView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: SPACE_XS).isActive = true
        commentTextContainerView.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        commentTextContainerView.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        commentTextContainerView.heightAnchor.constraint(equalToConstant: 15 + 15 + 15).isActive = true
        commentTextContainerView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        commentTextContainerView.addSubview(commentTextField)
        commentTextField.topAnchor.constraint(equalTo: commentTextContainerView.topAnchor).isActive = true
        commentTextField.leadingAnchor.constraint(equalTo: commentTextContainerView.leadingAnchor, constant: 15).isActive = true
        commentTextTrailingCons = commentTextField.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15)
        commentTextTrailingCons?.isActive = true
        commentTextField.bottomAnchor.constraint(equalTo: commentTextContainerView.bottomAnchor).isActive = true
        
        commentTextContainerView.addSubview(commentButton)
        commentButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor).isActive = true
        commentButton.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15).isActive = true
        
        view.addSubview(bottomButtonTopLine)
        bottomButtonTopLine.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        bottomButtonTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButtonTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomContainerBottomCons?.isActive = false
            bottomContainerBottomCons = bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            bottomContainerBottomCons?.isActive = true
            
            commentTextTrailingCons?.isActive = false
            commentTextTrailingCons = commentTextField.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -60)
            commentTextTrailingCons?.isActive = true
            
            commentButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.commentButton.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomContainerBottomCons?.isActive = false
        bottomContainerBottomCons = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomContainerBottomCons?.isActive = true
        
        commentTextTrailingCons?.isActive = false
        commentTextTrailingCons = commentTextField.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15)
        commentTextTrailingCons?.isActive = true
        
        commentTextField.text = ""
        
        UIView.animate(withDuration: 0.2, animations: {
            self.commentButton.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.commentButton.isHidden = true
        })
    }
    
    @objc func commentTapped() {
        guard let comment = commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if comment.count > 100 {
            let alert = UIAlertController(title: nil, message: "최대 100자 까지 입력 가능합니다.\n\n현재 \(comment.count) / 100", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
            
        } else {
            guard let posts = self.posts else { return }
            addPostsCommentRequest.fetch(vc: self, paramDict: ["poId": String(posts.po_id), "comment": comment])
        }
    }
    
    @objc func refreshed() {
        guard let posts = self.posts else { return }
        
        getPostsCommentsRequest.fetch(vc: self, paramDict: ["poId": String(posts.po_id)])
    }
}


// MARK: TableView
extension PostsCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCommentTVCell", for: indexPath) as! PostsCommentTVCell
        cell.selectionStyle = .none
        cell.postsComment = postsCommentList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
    }
}

// MARK: PostsCommentTVCell
extension PostsCommentViewController: PostsCommentTVCellProtocol {
    func selectUser(uId: Int) {
        dismissKeyboard()
        
        if app.getUserId() == uId { return }
        
        let userVC = UserViewController()
        userVC.uId = uId
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    func more(postsComment: PostsComment) {
        dismissKeyboard()
        
        let alert = UIAlertController(title: nil, message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "답글", style: .default, handler: { (_) in
            self.reComment(postsComment: postsComment)
        }))
        if postsComment.poc_u_id == app.getUserId() {
            alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { (_) in
                let alert = UIAlertController(title: nil, message: "정말 댓글을 삭제하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                    self.removePostsCommentRequest.fetch(vc: self, paramDict: ["pocId": String(postsComment.poc_id)])
                }))
                self.present(alert, animated: true, completion: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: { (_) in
                let reportVC = ReportViewController()
                reportVC.targetType = "POSTS_COMMENT"
                reportVC.targetId = postsComment.poc_id
                self.present(UINavigationController(rootViewController: reportVC), animated: true, completion: nil)
            }))
        }
        present(alert, animated: true)
    }
    
    func reComment(postsComment: PostsComment) {
        dismissKeyboard()
        
        let postsReCommentVC = PostsReCommentViewController()
        postsReCommentVC.postsComment = postsComment
        navigationController?.pushViewController(postsReCommentVC, animated: true)
    }
}

// MARK: HTTP - GetPostsComments
extension PostsCommentViewController: GetPostsCommentsRequestProtocol {
    func response(postsCommentList: [PostsComment]?, getPostsComments status: String) {
        print("[HTTP RES]", getPostsCommentsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsCommentList = postsCommentList else { return }
            
            self.postsCommentList = postsCommentList
            tableView.reloadData()
        }
        
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: HTTP - AddPostsComment
extension PostsCommentViewController: AddPostsCommentRequestProtocol {
    func response(postsComment: PostsComment?, addPostsComment status: String) {
        print("[HTTP RES]", addPostsCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsComment = postsComment else { return }
            
            dismissKeyboard()
            
            commentTextField.text = ""
            
            postsCommentList.append(postsComment)
            tableView.reloadData()
            
            tableView.selectRow(at: IndexPath(row: postsCommentList.count - 1, section: 0), animated: true, scrollPosition: .top)
        }
    }
}

// MARK: HTTP - RemovePostsComment
extension PostsCommentViewController: RemovePostsCommentRequestProtocol {
    func response(pocId: Int?, removePostsComment status: String) {
        print("[HTTP RES]", removePostsCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pocId = pocId else { return }
            
            for (i, postsComment) in postsCommentList.enumerated() {
                if postsComment.poc_id == pocId {
                    postsCommentList.remove(at: i)
                    break
                }
            }
            tableView.reloadData()
        }
    }
}
