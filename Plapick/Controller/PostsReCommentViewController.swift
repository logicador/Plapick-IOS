//
//  PostsReCommentViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/31.
//

import UIKit
import SDWebImage


class PostsReCommentViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var postsComment: PostsComment? {
        didSet {
            guard let postsComment = self.postsComment else { return }
            
            guard let profileImage = postsComment.u_profile_image else { return }
            guard let url = URL(string: PLAPICK_URL + profileImage) else { return }
            profileImageView.sd_setImage(with: url, completed: nil)
            
            nicknameLabel.text = postsComment.u_nickname
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let nowDate = Date()
            let nowString = df.string(from: nowDate)
            guard let startTime = df.date(from: postsComment.poc_created_date) else { return }
            guard let endTime = df.date(from: nowString) else { return }
            let useDay = Int(endTime.timeIntervalSince(startTime)) / 86400
            
            if useDay == 0 { dateLabel.text = "오늘" }
            else if (useDay > 0 && useDay < 7) || (useDay > 7 && useDay < 14) || (useDay > 14 && useDay < 21) { dateLabel.text = "\(useDay)일 전" }
            else if useDay == 7 || useDay == 14 || useDay == 21 { dateLabel.text = "\(useDay / 7)주 전" }
            else { dateLabel.text = postsComment.poc_created_date.split(separator: " ")[0].replacingOccurrences(of: "-", with: ". ") }
            
            commentLabel.text = postsComment.poc_comment
            
            getPostsReCommentsRequest.fetch(vc: self, paramDict: ["pocId": String(postsComment.poc_id)])
        }
    }
    let removePostsCommentRequest = RemovePostsCommentRequest()
    let getPostsReCommentsRequest = GetPostsReCommentsRequest()
    let addPostsReCommentRequest = AddPostsReCommentRequest()
    let removePostsReCommentRequest = RemovePostsReCommentRequest()
    var bottomContainerBottomCons: NSLayoutConstraint?
    var commentTextTrailingCons: NSLayoutConstraint?
    var commentTextLeadingCons: NSLayoutConstraint?
    var postsReCommentList: [PostsReComment] = []
    var targetUId: Int? = nil
    
    
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
        tf.placeholder = "이곳에 답글을 입력합니다. (100자 까지)"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var targetNicknameLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.alpha = 0
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    // MARK: View - PostsComment
    lazy var postsCommentContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(postsCommentTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray6
        iv.layer.borderWidth = LINE_WIDTH
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var moreContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moreTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var moreImageView: UIImageView = {
        let image = UIImage(systemName: "ellipsis")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var postsCommentBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - PostsReComment
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(PostsReCommentTVCell.self, forCellReuseIdentifier: "PostsReCommentTVCell")
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
    
    // MARK: View - Indicator
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    lazy var blurOverlayView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.alpha = 0.2
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        navigationItem.title = "답글"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureView()
        
        setThemeColor()
        
        removePostsCommentRequest.delegate = self
        getPostsReCommentsRequest.delegate = self
        addPostsReCommentRequest.delegate = self
        removePostsReCommentRequest.delegate = self
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        commentTextContainerView.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
        commentTextContainerView.layer.borderColor = UIColor.separator.cgColor
        
        profileImageView.layer.borderColor = UIColor.separator.cgColor
        
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
        commentTextLeadingCons = commentTextField.leadingAnchor.constraint(equalTo: commentTextContainerView.leadingAnchor, constant: 15)
        commentTextLeadingCons?.isActive = true
        commentTextTrailingCons = commentTextField.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15)
        commentTextTrailingCons?.isActive = true
        commentTextField.bottomAnchor.constraint(equalTo: commentTextContainerView.bottomAnchor).isActive = true
        
        commentTextContainerView.addSubview(targetNicknameLabel)
        targetNicknameLabel.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor).isActive = true
        targetNicknameLabel.leadingAnchor.constraint(equalTo: commentTextContainerView.leadingAnchor, constant: 15).isActive = true
        
        commentTextContainerView.addSubview(commentButton)
        commentButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor).isActive = true
        commentButton.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15).isActive = true
        
        view.addSubview(bottomButtonTopLine)
        bottomButtonTopLine.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        bottomButtonTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomButtonTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: Configure - PostsComment
        view.addSubview(postsCommentContainerView)
        postsCommentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        postsCommentContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postsCommentContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        postsCommentContainerView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: postsCommentContainerView.topAnchor, constant: SPACE).isActive = true
        stackView.leadingAnchor.constraint(equalTo: postsCommentContainerView.leadingAnchor, constant: 40 + SPACE_XS).isActive = true
        stackView.trailingAnchor.constraint(equalTo: postsCommentContainerView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: postsCommentContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        stackView.addArrangedSubview(headerContainerView)
        headerContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        headerContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(nicknameLabel)
        nicknameLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        nicknameLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        nicknameLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        headerContainerView.addSubview(dateLabel)
        dateLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: SPACE_XXS).isActive = true
        
        headerContainerView.addSubview(moreContainerView)
        moreContainerView.topAnchor.constraint(equalTo: nicknameLabel.topAnchor).isActive = true
        moreContainerView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        moreContainerView.bottomAnchor.constraint(equalTo: nicknameLabel.bottomAnchor).isActive = true
        
        moreContainerView.addSubview(moreImageView)
        moreImageView.centerYAnchor.constraint(equalTo: moreContainerView.centerYAnchor).isActive = true
        moreImageView.leadingAnchor.constraint(equalTo: moreContainerView.leadingAnchor, constant: SPACE_XXS).isActive = true
        moreImageView.trailingAnchor.constraint(equalTo: moreContainerView.trailingAnchor).isActive = true
        moreImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        moreImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        stackView.addArrangedSubview(commentLabel)
        commentLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        postsCommentContainerView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: postsCommentContainerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(postsCommentBottomLine)
        postsCommentBottomLine.topAnchor.constraint(equalTo: postsCommentContainerView.bottomAnchor).isActive = true
        postsCommentBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postsCommentBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: Configure - PostsReComment
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: postsCommentBottomLine.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
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
        
        commentTextLeadingCons?.isActive = false
        commentTextLeadingCons = commentTextField.leadingAnchor.constraint(equalTo: commentTextContainerView.leadingAnchor, constant: 15)
        commentTextLeadingCons?.isActive = true
        
        commentTextTrailingCons?.isActive = false
        commentTextTrailingCons = commentTextField.trailingAnchor.constraint(equalTo: commentTextContainerView.trailingAnchor, constant: -15)
        commentTextTrailingCons?.isActive = true
        
        targetUId = nil
        commentTextField.text = ""
        targetNicknameLabel.text = ""
        
        UIView.animate(withDuration: 0.2, animations: {
            self.commentButton.alpha = 0
            self.targetNicknameLabel.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.commentButton.isHidden = true
            self.targetNicknameLabel.isHidden = true
        })
    }
    
    @objc func commentTapped() {
        guard let comment = commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if comment.count > 100 {
            let alert = UIAlertController(title: nil, message: "최대 100자 까지 입력 가능합니다.\n\n현재 \(comment.count) / 100", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true, completion: nil)
            
        } else {
            guard let postsComment = self.postsComment else { return }
            var paramDict: [String: String] = ["poId": String(postsComment.poc_po_id), "pocId": String(postsComment.poc_id), "comment": comment]
            
            if let targetUId = self.targetUId {
                paramDict["targetUId"] = String(targetUId)
            }
            
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            addPostsReCommentRequest.fetch(vc: self, paramDict: paramDict)
        }
    }
    
    @objc func refreshed() {
        guard let postsComment = self.postsComment else { return }
        
        getPostsReCommentsRequest.fetch(vc: self, paramDict: ["pocId": String(postsComment.poc_id)])
    }
    
    @objc func postsCommentTapped() {
        dismissKeyboard()
    }
    
    @objc func userTapped() {
        dismissKeyboard()
        
        guard let postsComment = self.postsComment else { return }
        
        if app.getUserId() == postsComment.poc_u_id { return }
        
        let userVC = UserViewController()
        userVC.uId = postsComment.poc_u_id
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    @objc func moreTapped() {
        dismissKeyboard()
        
        guard let postsComment = self.postsComment else { return }
        
        let alert = UIAlertController(title: nil, message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        
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
}


// MARK: TableView
extension PostsReCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsReCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsReCommentTVCell", for: indexPath) as! PostsReCommentTVCell
        cell.selectionStyle = .none
        cell.postsReComment = postsReCommentList[indexPath.row]
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

// MARK: PostsReCommentTVCell
extension PostsReCommentViewController: PostsReCommentTVCellProtocol {
    func selectUser(uId: Int) {
        dismissKeyboard()
        
        if app.getUserId() == uId { return }
        
        let userVC = UserViewController()
        userVC.uId = uId
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    func more(postsReComment: PostsReComment) {
        dismissKeyboard()
        
        let alert = UIAlertController(title: nil, message: "다음 중 항목을 선택해주세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "답글달기", style: .default, handler: { (_) in
            self.reComment(postsReComment: postsReComment)
        }))
        if postsReComment.porc_u_id == app.getUserId() {
            alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { (_) in
                let alert = UIAlertController(title: nil, message: "정말 답글을 삭제하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                    self.removePostsReCommentRequest.fetch(vc: self, paramDict: ["porcId": String(postsReComment.porc_id)])
                }))
                self.present(alert, animated: true, completion: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: { (_) in
                let reportVC = ReportViewController()
                reportVC.targetType = "POSTS_RE_COMMENT"
                reportVC.targetId = postsReComment.porc_id
                self.present(UINavigationController(rootViewController: reportVC), animated: true, completion: nil)
            }))
        }
        present(alert, animated: true)
    }
    
    func reComment(postsReComment: PostsReComment) {
        targetUId = postsReComment.porc_u_id
        
        targetNicknameLabel.text = "@\(postsReComment.u_nickname)"
        
        targetNicknameLabel.isHidden = false
        
        commentTextLeadingCons?.isActive = false
        commentTextLeadingCons = commentTextField.leadingAnchor.constraint(equalTo: targetNicknameLabel.trailingAnchor, constant: 15)
        commentTextLeadingCons?.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.targetNicknameLabel.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.commentTextField.becomeFirstResponder()
        })
    }
    
    func selectTargetUser(uId: Int) {
        dismissKeyboard()
        
        print("selectTargetUser, uId")
    }
}

// MARK: HTTP - RemovePostsComment
extension PostsReCommentViewController: RemovePostsCommentRequestProtocol {
    func response(pocId: Int?, removePostsComment status: String) {
        print("[HTTP RES]", removePostsCommentRequest.apiUrl, status)
        
        if status == "OK" {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: HTTP - GetPostsReComments
extension PostsReCommentViewController: GetPostsReCommentsRequestProtocol {
    func response(postsReCommentList: [PostsReComment]?, getPostsReComments status: String) {
        print("[HTTP RES]", getPostsReCommentsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsReCommentList = postsReCommentList else { return }
            
            self.postsReCommentList = postsReCommentList
            tableView.reloadData()
        }
        
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: HTTP - AddPostsReComment
extension PostsReCommentViewController: AddPostsReCommentRequestProtocol {
    func response(postsReComment: PostsReComment?, addPostsReComment status: String) {
        print("[HTTP RES]", addPostsReCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let postsReComment = postsReComment else { return }
            
            dismissKeyboard()
            
            commentTextField.text = ""
            
            postsReCommentList.append(postsReComment)
            tableView.reloadData()
            
            tableView.selectRow(at: IndexPath(row: postsReCommentList.count - 1, section: 0), animated: true, scrollPosition: .top)
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - RemovePostsReComment
extension PostsReCommentViewController: RemovePostsReCommentRequestProtocol {
    func response(porcId: Int?, removePostsReComment status: String) {
        print("[HTTP RES]", removePostsReCommentRequest.apiUrl, status)
        
        if status == "OK" {
            guard let porcId = porcId else { return }
            
            for (i, postsReComment) in postsReCommentList.enumerated() {
                if postsReComment.porc_id == porcId {
                    postsReCommentList.remove(at: i)
                    break
                }
            }
            tableView.reloadData()
        }
    }
}
